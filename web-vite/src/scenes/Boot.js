import { Scene } from '../engine/Game.js';

/**
 * Boot / loading scene. Preloads assets and shows progress on screen,
 * then transitions to the Title scene.
 */
export class Boot extends Scene {
  enter() {
    /** @type {Array<{key: string, src: string}>} */
    this._assets = [
      // Add asset paths here as they are created, e.g.:
      // { key: 'player', src: 'assets/sprites/player.png' },
    ];

    this._loaded = 0;
    this._total = this._assets.length;
    /** @type {Map<string, HTMLImageElement>} */
    this._images = new Map();
    this._done = false;

    this._loadAssets();
  }

  /** Kick off all asset loads in parallel */
  async _loadAssets() {
    if (this._total === 0) {
      this._finish();
      return;
    }

    const promises = this._assets.map((asset) => this._loadImage(asset));
    await Promise.all(promises);
    this._finish();
  }

  /**
   * Load a single image asset.
   * @param {{ key: string, src: string }} asset
   * @returns {Promise<void>}
   */
  _loadImage({ key, src }) {
    return new Promise((resolve) => {
      const img = new Image();
      img.onload = () => {
        this._images.set(key, img);
        this._loaded++;
        resolve();
      };
      img.onerror = () => {
        console.warn(`[Boot] Failed to load: ${src}`);
        this._loaded++;
        resolve();
      };
      img.src = src;
    });
  }

  /** Transition to the next scene */
  _finish() {
    this.game.state.assets = this._images;
    this._done = true;

    const { Title } = /** @type {*} */ (window.__boot_title_import);
    // Dynamic import avoids circular dependency in case Title references Boot
    import('./Title.js').then(({ Title: T }) => {
      this.game.loadScene(new T(this.game));
    });
  }

  render(renderer) {
    renderer.fillRect(0, 0, renderer.virtualWidth, renderer.virtualHeight, '#0a0a0f');

    const progress = this._total > 0 ? this._loaded / this._total : 1;
    const vw = renderer.virtualWidth;
    const vh = renderer.virtualHeight;

    renderer.drawText('Loading...', vw / 2, vh / 2 - 30, {
      font: '16px monospace',
      color: '#c0c0c0',
      align: 'center'
    });

    // Progress bar
    const barW = 200;
    const barH = 4;
    const barX = (vw - barW) / 2;
    const barY = vh / 2;
    renderer.fillRect(barX, barY, barW, barH, '#1a1a2e');
    renderer.fillRect(barX, barY, barW * progress, barH, '#4a9eff');

    renderer.drawText(`${Math.round(progress * 100)}%`, vw / 2, barY + 12, {
      font: '12px monospace',
      color: '#666666',
      align: 'center'
    });
  }
}
