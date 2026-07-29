/**
 * Canvas 2D renderer with responsive scaling.
 */
export class Renderer {
  /** @param {HTMLCanvasElement} canvas */
  constructor(canvas) {
    this.canvas = canvas;
    /** @type {CanvasRenderingContext2D} */
    this.ctx = canvas.getContext('2d');

    /** Virtual/game resolution */
    this.virtualWidth = 480;
    this.virtualHeight = 720;

    this._scale = 1;
    this._offsetX = 0;
    this._offsetY = 0;
  }

  /** Initialise canvas, compute initial scale, attach resize listener. */
  init() {
    this._resize();
    this._onResize = () => this._resize();
    window.addEventListener('resize', this._onResize, { passive: true });

    this.ctx.imageSmoothingEnabled = false;
  }

  /** Remove listeners */
  destroy() {
    window.removeEventListener('resize', this._onResize);
  }

  /** Recalculate canvas size and scaling to fill the window while keeping aspect ratio. */
  _resize() {
    const dpr = window.devicePixelRatio || 1;
    const winW = window.innerWidth;
    const winH = window.innerHeight;

    const aspect = this.virtualWidth / this.virtualHeight;
    let w, h;
    if (winW / winH > aspect) {
      h = winH;
      w = h * aspect;
    } else {
      w = winW;
      h = w / aspect;
    }

    this._scale = w / this.virtualWidth;
    this._offsetX = (winW - w) / 2;
    this._offsetY = (winH - h) / 2;

    this.canvas.width = Math.round(this.virtualWidth * dpr);
    this.canvas.height = Math.round(this.virtualHeight * dpr);
    this.canvas.style.width = `${Math.round(w)}px`;
    this.canvas.style.height = `${Math.round(h)}px`;
    this.canvas.style.position = 'absolute';
    this.canvas.style.left = `${this._offsetX}px`;
    this.canvas.style.top = `${this._offsetY}px`;

    this.ctx.setTransform(dpr * this._scale, 0, 0, dpr * this._scale, 0, 0);
    this.ctx.imageSmoothingEnabled = false;
  }

  /** Clear the entire canvas */
  clear() {
    const { ctx, virtualWidth: w, virtualHeight: h } = this;
    ctx.clearRect(0, 0, w, h);
  }

  /**
   * Fill a rectangle.
   * @param {number} x
   * @param {number} y
   * @param {number} w
   * @param {number} h
   * @param {string} color
   */
  fillRect(x, y, w, h, color) {
    this.ctx.fillStyle = color;
    this.ctx.fillRect(x, y, w, h);
  }

  /**
   * Draw an image (sprite) onto the canvas.
   * @param {HTMLImageElement|HTMLCanvasElement} image
   * @param {number} x
   * @param {number} y
   * @param {number} [w] - draw width (defaults to image width)
   * @param {number} [h] - draw height (defaults to image height)
   * @param {{ flipX?: boolean, rotation?: number, alpha?: number }} [opts]
   */
  drawSprite(image, x, y, w, h, opts = {}) {
    const { ctx } = this;
    const dw = w ?? image.width;
    const dh = h ?? image.height;

    ctx.save();
    ctx.globalAlpha = opts.alpha ?? 1;

    if (opts.flipX || opts.rotation) {
      ctx.translate(x + dw / 2, y + dh / 2);
      if (opts.rotation) ctx.rotate(opts.rotation);
      if (opts.flipX) ctx.scale(-1, 1);
      ctx.drawImage(image, -dw / 2, -dh / 2, dw, dh);
    } else {
      ctx.drawImage(image, x, y, dw, dh);
    }

    ctx.restore();
  }

  /**
   * Draw text.
   * @param {string} text
   * @param {number} x
   * @param {number} y
   * @param {{ font?: string, color?: string, align?: string, maxWidth?: number }} [opts]
   */
  drawText(text, x, y, opts = {}) {
    const { ctx } = this;
    ctx.save();
    ctx.font = opts.font ?? '14px monospace';
    ctx.fillStyle = opts.color ?? '#ffffff';
    ctx.textAlign = opts.align ?? 'left';
    ctx.textBaseline = 'top';

    if (opts.maxWidth) {
      this._wrapText(text, x, y, opts.maxWidth);
    } else {
      ctx.fillText(text, x, y);
    }

    ctx.restore();
  }

  /**
   * Simple word-wrap text drawing.
   * @param {string} text
   * @param {number} x
   * @param {number} y
   * @param {number} maxWidth
   */
  _wrapText(text, x, y, maxWidth) {
    const { ctx } = this;
    const words = text.split(' ');
    let line = '';
    let lineY = y;
    const lineHeight = parseInt(ctx.font, 10) || 16;

    for (const word of words) {
      const test = line ? `${line} ${word}` : word;
      if (ctx.measureText(test).width > maxWidth && line) {
        ctx.fillText(line, x, lineY);
        line = word;
        lineY += lineHeight;
      } else {
        line = test;
      }
    }
    if (line) ctx.fillText(line, x, lineY);
  }
}
