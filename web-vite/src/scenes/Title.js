import { Scene } from '../engine/Game.js';

/** Blink interval for the "press to start" prompt (seconds) */
const BLINK_RATE = 0.6;

/**
 * Title / main menu screen.
 */
export class Title extends Scene {
  enter() {
    this._blinkTimer = 0;
    this._showPrompt = true;
  }

  update(dt) {
    this._blinkTimer += dt;
    if (this._blinkTimer >= BLINK_RATE) {
      this._blinkTimer -= BLINK_RATE;
      this._showPrompt = !this._showPrompt;
    }

    const input = this.game.input;

    if (input.isKeyPressed('Enter') || input.isKeyPressed('Space') || input.tapped) {
      this._startGame();
    }
  }

  /** Transition to the first gameplay scene (placeholder) */
  _startGame() {
    // For now, stay on title; a real GamePlay scene will replace this.
    console.log('[Title] Start pressed — scene transition will go here');
  }

  render(renderer) {
    const vw = renderer.virtualWidth;
    const vh = renderer.virtualHeight;

    renderer.fillRect(0, 0, vw, vh, '#0a0a0f');

    renderer.drawText('IAI SURVIVORS', vw / 2, vh * 0.3, {
      font: 'bold 28px monospace',
      color: '#ffffff',
      align: 'center'
    });

    renderer.drawText('A survival / management game', vw / 2, vh * 0.3 + 40, {
      font: '12px monospace',
      color: '#666666',
      align: 'center'
    });

    if (this._showPrompt) {
      renderer.drawText('Press ENTER or tap to start', vw / 2, vh * 0.65, {
        font: '14px monospace',
        color: '#4a9eff',
        align: 'center'
      });
    }
  }
}
