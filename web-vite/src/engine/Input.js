/**
 * Input handler: keyboard, touch, and virtual joystick.
 */
export class Input {
  /** @param {HTMLCanvasElement} canvas */
  constructor(canvas) {
    this.canvas = canvas;

    /** Currently held keys (by event.code) */
    this.keys = {};

    /** Keys pressed this frame (consumed after update) */
    this.keysPressed = {};

    /** True while the screen/canvas is being touched */
    this.touching = false;

    /** Normalised virtual joystick vector {x: -1..1, y: -1..1} */
    this.joystick = { x: 0, y: 0 };

    /** Tap event detected this frame (single tap) */
    this.tapped = false;

    /** Tap position in virtual coords */
    this.tapPosition = null;

    this._listeners = [];

    this._joystickStart = null;
    this._joystickTouchId = null;
    this._joystickRadius = 40;
  }

  /** Attach all event listeners */
  init() {
    const add = (el, type, fn, opts) => {
      el.addEventListener(type, fn, opts);
      this._listeners.push({ el, type, fn });
    };

    add(window, 'keydown', (e) => {
      if (!this.keys[e.code]) this.keysPressed[e.code] = true;
      this.keys[e.code] = true;
    });
    add(window, 'keyup', (e) => {
      this.keys[e.code] = false;
    });

    add(this.canvas, 'touchstart', (e) => this._onTouchStart(e), { passive: false });
    add(this.canvas, 'touchmove', (e) => this._onTouchMove(e), { passive: false });
    add(this.canvas, 'touchend', (e) => this._onTouchEnd(e), { passive: false });
    add(this.canvas, 'touchcancel', (e) => this._onTouchEnd(e), { passive: false });

    add(this.canvas, 'mousedown', (e) => this._onMouseDown(e));
    add(this.canvas, 'mouseup', (e) => this._onMouseUp(e));
  }

  /** Remove all listeners */
  destroy() {
    for (const { el, type, fn } of this._listeners) {
      el.removeEventListener(type, fn);
    }
    this._listeners = [];
  }

  /**
   * Call once per fixed update to reset per-frame flags.
   * Must be called AFTER scene has read the input.
   */
  update() {
    this.keysPressed = {};
    this.tapped = false;
    this.tapPosition = null;
  }

  /**
   * Check if a key was just pressed this frame.
   * @param {string} code - KeyboardEvent.code
   * @returns {boolean}
   */
  isKeyPressed(code) {
    return !!this.keysPressed[code];
  }

  /**
   * Check if a key is currently held.
   * @param {string} code
   * @returns {boolean}
   */
  isKeyHeld(code) {
    return !!this.keys[code];
  }

  /** Get movement vector from arrow keys / WASD */
  getKeyboardMove() {
    let x = 0, y = 0;
    if (this.isKeyHeld('ArrowLeft') || this.isKeyHeld('KeyA')) x -= 1;
    if (this.isKeyHeld('ArrowRight') || this.isKeyHeld('KeyD')) x += 1;
    if (this.isKeyHeld('ArrowUp') || this.isKeyHeld('KeyW')) y -= 1;
    if (this.isKeyHeld('ArrowDown') || this.isKeyHeld('KeyS')) y += 1;
    return { x, y };
  }

  /** Get the combined movement (joystick + keyboard, normalised) */
  getMoveVector() {
    const kb = this.getKeyboardMove();
    let x = kb.x + this.joystick.x;
    let y = kb.y + this.joystick.y;
    const len = Math.sqrt(x * x + y * y);
    if (len > 1) { x /= len; y /= len; }
    return { x, y };
  }

  // ── Touch / Joystick ──────────────────────────────────────

  /**
   * @param {TouchList} touches
   * @returns {Touch|undefined}
   */
  _findJoystickTouch(touches) {
    for (let i = 0; i < touches.length; i++) {
      if (touches[i].identifier === this._joystickTouchId) return touches[i];
    }
    return undefined;
  }

  /** @param {TouchEvent} e */
  _onTouchStart(e) {
    e.preventDefault();
    this.touching = true;

    if (this._joystickTouchId === null) {
      const touch = e.changedTouches[0];
      this._joystickTouchId = touch.identifier;
      const rect = this.canvas.getBoundingClientRect();
      this._joystickStart = {
        x: touch.clientX - rect.left,
        y: touch.clientY - rect.top
      };
    }
  }

  /** @param {TouchEvent} e */
  _onTouchMove(e) {
    e.preventDefault();
    if (this._joystickStart === null) return;

    const touch = this._findJoystickTouch(e.changedTouches);
    if (!touch) return;

    const rect = this.canvas.getBoundingClientRect();
    const dx = (touch.clientX - rect.left) - this._joystickStart.x;
    const dy = (touch.clientY - rect.top) - this._joystickStart.y;
    const dist = Math.sqrt(dx * dx + dy * dy);
    const maxDist = this._joystickRadius;

    if (dist > maxDist) {
      this.joystick.x = dx / dist;
      this.joystick.y = dy / dist;
    } else {
      this.joystick.x = dx / maxDist;
      this.joystick.y = dy / maxDist;
    }
  }

  /** @param {TouchEvent} e */
  _onTouchEnd(e) {
    e.preventDefault();

    const touch = this._findJoystickTouch(e.changedTouches);
    if (touch) {
      this._joystickTouchId = null;
      this._joystickStart = null;
      this.joystick.x = 0;
      this.joystick.y = 0;
    }

    if (e.touches.length === 0) {
      this.touching = false;
      this.tapped = true;
      const rect = this.canvas.getBoundingClientRect();
      const last = e.changedTouches[0];
      this.tapPosition = {
        x: last.clientX - rect.left,
        y: last.clientY - rect.top
      };
    }
  }

  /** @param {MouseEvent} e */
  _onMouseDown(e) {
    this.touching = true;
    this.tapped = true;
    const rect = this.canvas.getBoundingClientRect();
    this.tapPosition = { x: e.clientX - rect.left, y: e.clientY - rect.top };
  }

  /** @param {MouseEvent} e */
  _onMouseUp(_e) {
    this.touching = false;
  }
}
