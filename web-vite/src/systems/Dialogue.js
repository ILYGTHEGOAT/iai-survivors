/**
 * Dialogue system with typewriter text animation and branching choices.
 *
 * Usage:
 *   const dialogue = new Dialogue();
 *   dialogue.start([
 *     { speaker: 'Narrator', text: 'You awaken...' },
 *     { speaker: 'AI', text: 'Choose your path.', choices: [
 *       { text: 'Go left', next: 2 },
 *       { text: 'Go right', next: 3 },
 *     ]},
 *     { speaker: 'Narrator', text: 'You go left.' },
 *     { speaker: 'Narrator', text: 'You go right.' },
 *   ]);
 *
 *   // In update(dt): dialogue.update(dt)
 *   // In render(renderer): dialogue.render(renderer)
 *   // To advance: dialogue.advance()
 *   // To choose:  dialogue.choose(index)
 */

/**
 * @typedef {Object} DialogueLine
 * @property {string} speaker
 * @property {string} text
 * @property {Array<{text: string, next?: number}>} [choices]
 */

export class Dialogue {
  constructor() {
    /** @type {DialogueLine[]} */
    this.lines = [];
    /** Current line index */
    this.index = 0;
    /** Characters displayed so far (for typewriter effect) */
    this._displayedChars = 0;
    /** Characters per second */
    this.charsPerSecond = 30;
    /** Is the current line fully displayed? */
    this.isComplete = false;
    /** Currently selected choice index (for rendering highlight) */
    this.selectedChoice = 0;
    /** Whether dialogue is active */
    this.active = false;
    /** Callback when dialogue ends */
    this.onEnd = null;
    /** Callback when a choice is selected: (choiceIndex, lineIndex) => void */
    this.onChoice = null;
  }

  /**
   * Begin a dialogue sequence.
   * @param {DialogueLine[]} lines
   * @param {function} [onEnd]
   */
  start(lines, onEnd) {
    this.lines = lines;
    this.index = 0;
    this._displayedChars = 0;
    this.isComplete = false;
    this.selectedChoice = 0;
    this.active = true;
    this.onEnd = onEnd ?? null;
  }

  /** Skip to the end of the current line's text */
  advance() {
    if (!this.active) return;

    if (!this.isComplete) {
      this._displayedChars = this.currentLine().text.length;
      this.isComplete = true;
      return;
    }

    const line = this.currentLine();
    if (line.choices && line.choices.length > 0) {
      // Wait for choose() call
      return;
    }

    this._nextLine();
  }

  /**
   * Select a choice (index-based).
   * @param {number} index
   */
  choose(index) {
    if (!this.active) return;
    const line = this.currentLine();
    if (!line.choices || index >= line.choices.length) return;

    this.selectedChoice = index;
    this.onChoice?.(index, this.index);

    const choice = line.choices[index];
    if (choice.next !== undefined) {
      this.index = choice.next;
    } else {
      this.index++;
    }
    this._resetLine();
  }

  /**
   * Move selectedChoice by delta (for keyboard/gamepad navigation).
   * @param {number} delta
   */
  moveSelection(delta) {
    const line = this.currentLine();
    if (!line.choices) return;
    this.selectedChoice = (this.selectedChoice + delta + line.choices.length) % line.choices.length;
  }

  /** Get the current line object */
  currentLine() {
    return this.lines[this.index] ?? { speaker: '', text: '', choices: [] };
  }

  /**
   * Update typewriter animation.
   * @param {number} dt - seconds
   */
  update(dt) {
    if (!this.active) return;

    const line = this.currentLine();
    if (this._displayedChars < line.text.length) {
      this._displayedChars += this.charsPerSecond * dt;
      if (this._displayedChars >= line.text.length) {
        this._displayedChars = line.text.length;
        this.isComplete = true;
      }
    } else {
      this.isComplete = true;
    }
  }

  /**
   * Render the dialogue box.
   * @param {import('../engine/Renderer.js').Renderer} renderer
   */
  render(renderer) {
    if (!this.active) return;

    const vw = renderer.virtualWidth;
    const vh = renderer.virtualHeight;
    const line = this.currentLine();

    // Box dimensions
    const boxH = 140;
    const boxY = vh - boxH - 10;
    const boxX = 10;
    const boxW = vw - 20;

    // Background
    renderer.fillRect(boxX, boxY, boxW, boxH, 'rgba(10, 10, 20, 0.92)');
    renderer.fillRect(boxX, boxY, boxW, 2, '#4a9eff');

    // Speaker
    renderer.drawText(line.speaker, boxX + 12, boxY + 10, {
      font: 'bold 13px monospace',
      color: '#4a9eff'
    });

    // Text (typewriter)
    const visibleText = line.text.slice(0, Math.floor(this._displayedChars));
    renderer.drawText(visibleText, boxX + 12, boxY + 30, {
      font: '13px monospace',
      color: '#c0c0c0',
      maxWidth: boxW - 24
    });

    // Choices
    if (this.isComplete && line.choices && line.choices.length > 0) {
      const startY = boxY + 60;
      line.choices.forEach((choice, i) => {
        const prefix = i === this.selectedChoice ? '▸ ' : '  ';
        const color = i === this.selectedChoice ? '#ffffff' : '#888888';
        renderer.drawText(`${prefix}${choice.text}`, boxX + 16, startY + i * 20, {
          font: '12px monospace',
          color
        });
      });
    }

    // Advance prompt
    if (this.isComplete && (!line.choices || line.choices.length === 0)) {
      renderer.drawText('▼', boxX + boxW - 20, boxY + boxH - 18, {
        font: '10px monospace',
        color: '#4a9eff'
      });
    }
  }

  /** @private Advance to the next line, or end dialogue */
  _nextLine() {
    this.index++;
    if (this.index >= this.lines.length) {
      this.active = false;
      this.onEnd?.();
      return;
    }
    this._resetLine();
  }

  /** @private Reset typewriter state for a new line */
  _resetLine() {
    this._displayedChars = 0;
    this.isComplete = false;
    this.selectedChoice = 0;
  }
}
