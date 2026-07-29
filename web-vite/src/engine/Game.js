/** @typedef {import('./Renderer.js').Renderer} Renderer */
/** @typedef {import('./Input.js').Input} Input */
/** @typedef {import('./Storage.js').Storage} Storage */

/**
 * @typedef {Object} GameOptions
 * @property {Renderer} renderer
 * @property {Input} input
 * @property {Storage} storage
 */

/**
 * Main game class. Owns the game loop, scene stack, and shared state.
 */
export class Game {
  /** @param {GameOptions} opts */
  constructor({ renderer, input, storage }) {
    this.renderer = renderer;
    this.input = input;
    this.storage = storage;

    /** @type {Scene|null} */
    this.scene = null;

    /** @type {Object.<string, any>} Global shared state (player data, inventory, etc.) */
    this.state = {};

    this._running = false;
    this._raf = 0;
    this._lastTime = 0;
    this._dt = 0;
    this._accumulator = 0;

    /** Fixed timestep for physics/logic (16.666 ms ≈ 60 fps) */
    this.fixedDt = 1000 / 60;

    /** Max frame delta to prevent spiral of death */
    this.maxFrameTime = 250;
  }

  /** Initialize subsystems (call once before first scene) */
  async init() {
    this.renderer.init();
    this.input.init();
    this.storage.init();
    return this;
  }

  /**
   * Swap to a new scene, calling exit/enter lifecycle hooks.
   * @param {Scene} newScene
   */
  loadScene(newScene) {
    if (this.scene && typeof this.scene.exit === 'function') {
      this.scene.exit();
    }
    this.scene = newScene;
    if (typeof this.scene.enter === 'function') {
      this.scene.enter();
    }
  }

  /** Start the game loop */
  start() {
    if (this._running) return;
    this._running = true;
    this._lastTime = performance.now();
    this._accumulator = 0;
    this._tick = this._tick.bind(this);
    this._raf = requestAnimationFrame(this._tick);
  }

  /** Pause the game loop (keeps scene alive) */
  pause() {
    this._running = false;
    cancelAnimationFrame(this._raf);
  }

  /** Resume the game loop */
  resume() {
    if (this._running) return;
    this._running = true;
    this._lastTime = performance.now();
    this._accumulator = 0;
    this._raf = requestAnimationFrame(this._tick);
  }

  /** Stop and tear down everything */
  destroy() {
    this._running = false;
    cancelAnimationFrame(this._raf);
    this.input?.destroy();
    this.renderer?.destroy();
    if (this.scene && typeof this.scene.exit === 'function') {
      this.scene.exit();
    }
  }

  /**
   * Core loop tick. Calculates delta time, runs fixed updates, then renders.
   * @param {number} now - performance.now() timestamp
   */
  _tick(now) {
    if (!this._running) return;

    let frameTime = now - this._lastTime;
    this._lastTime = now;
    if (frameTime > this.maxFrameTime) frameTime = this.maxFrameTime;

    this._dt = frameTime;
    this._accumulator += frameTime;

    while (this._accumulator >= this.fixedDt) {
      this._fixedUpdate(this.fixedDt / 1000);
      this._accumulator -= this.fixedDt;
    }

    this._render();

    this._raf = requestAnimationFrame(this._tick);
  }

  /**
   * Fixed-rate update. Calls the current scene's update().
   * @param {number} dt - seconds since last fixed step
   */
  _fixedUpdate(dt) {
    if (this.scene && typeof this.scene.update === 'function') {
      this.scene.update(dt, this);
    }
    this.input.update();
  }

  /** Render the current scene */
  _render() {
    this.renderer.clear();
    if (this.scene && typeof this.scene.render === 'function') {
      this.scene.render(this.renderer, this);
    }
  }
}

/**
 * Base scene interface. All scenes should implement at least enter()/exit().
 * @abstract
 */
export class Scene {
  /** @param {Game} game */
  constructor(game) {
    this.game = game;
    if (new.target === Scene) throw new Error('Scene is abstract');
  }

  /** Called when this scene becomes active */
  enter() {}

  /** Called when this scene is replaced */
  exit() {}

  /**
   * Called at a fixed timestep (60 fps).
   * @param {number} dt - seconds
   * @param {Game} game
   */
  update(dt, game) {}

  /**
   * Called every animation frame.
   * @param {Renderer} renderer
   * @param {Game} game
   */
  render(renderer, game) {}
}
