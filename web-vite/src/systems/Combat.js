/**
 * Turn-based combat system.
 */

/**
 * @typedef {Object} Combatant
 * @property {string} name
 * @property {number} hp
 * @property {number} maxHp
 * @property {number} attack
 * @property {number} defense
 * @property {number} speed
 * @property {boolean} [isEnemy]
 */

/**
 * @typedef {Object} CombatAction
 * @property {string} type - 'attack' | 'defend' | 'skill' | 'item'
 * @property {string} [skillId]
 * @property {string} [itemId]
 */

/**
 * @typedef {Object} CombatResult
 * @property {'victory'|'defeat'|'ongoing'} outcome
 * @property {string} log
 */

export class Combat {
  constructor() {
    /** @type {Combatant[]} */
    this.party = [];
    /** @type {Combatant[]} */
    this.enemies = [];
    /** @type {number} */
    this.turnIndex = 0;
    /** @type {'player'|'enemy'|'resolving'} */
    this.phase = 'player';
    /** @type {string[]} */
    this.log = [];
    this._onAction = null;
    this._onEnd = null;
  }

  /**
   * Start a new combat encounter.
   * @param {Combatant[]} party
   * @param {Combatant[]} enemies
   * @param {{ onAction?: (log: string) => void, onEnd?: (result: CombatResult) => void }} [callbacks]
   */
  start(party, enemies, callbacks = {}) {
    this.party = party.filter((c) => c.hp > 0);
    this.enemies = enemies.filter((c) => c.hp > 0);
    this.turnIndex = 0;
    this.phase = 'player';
    this.log = [];
    this._onAction = callbacks.onAction ?? null;
    this._onEnd = callbacks.onEnd ?? null;

    this._sortTurnOrder();
    this._log('Combat begins!');
  }

  /** @private Sort all combatants by speed (descending) */
  _sortTurnOrder() {
    this._turnOrder = [...this.party, ...this.enemies].filter((c) => c.hp > 0);
    this._turnOrder.sort((a, b) => b.speed - a.speed);
    this.turnIndex = 0;
  }

  /**
   * Get the current combatant whose turn it is.
   * @returns {Combatant|null}
   */
  getCurrentCombatant() {
    if (this.turnIndex >= this._turnOrder.length) return null;
    return this._turnOrder[this.turnIndex] ?? null;
  }

  /**
   * Execute an action for the current combatant.
   * @param {CombatAction} action
   * @returns {CombatResult}
   */
  executeAction(action) {
    const actor = this.getCurrentCombatant();
    if (!actor) return { outcome: 'ongoing', log: 'No active combatant.' };

    if (action.type === 'attack') {
      const targets = actor.isEnemy ? this.party : this.enemies;
      const target = targets.find((t) => t.hp > 0);
      if (target) this._resolveAttack(actor, target);
    } else if (action.type === 'defend') {
      this._log(`${actor.name} defends!`);
    } else if (action.type === 'skill' && action.skillId) {
      this._log(`${actor.name} uses ${action.skillId}!`);
      // Skill resolution to be implemented per-game
    }

    const result = this._checkEnd();
    if (result.outcome !== 'ongoing') return result;

    this._advanceTurn();
    return { outcome: 'ongoing', log: this.log[this.log.length - 1] ?? '' };
  }

  /**
   * @private Resolve a basic attack.
   * @param {Combatant} attacker
   * @param {Combatant} target
   */
  _resolveAttack(attacker, target) {
    const rawDamage = attacker.attack - target.defense;
    const damage = Math.max(1, rawDamage + this._randInt(-1, 1));
    target.hp = Math.max(0, target.hp - damage);
    this._log(`${attacker.name} hits ${target.name} for ${damage} damage!`);
  }

  /** @private Advance to the next living combatant, or resolve round */
  _advanceTurn() {
    this.turnIndex++;
    if (this.turnIndex >= this._turnOrder.length) {
      this._sortTurnOrder();
    }
    // Skip dead combatants
    while (this.turnIndex < this._turnOrder.length && this._turnOrder[this.turnIndex].hp <= 0) {
      this.turnIndex++;
    }
    if (this.turnIndex >= this._turnOrder.length) {
      this._sortTurnOrder();
    }
  }

  /** @private Check if combat has ended */
  _checkEnd() {
    const partyAlive = this.party.some((c) => c.hp > 0);
    const enemiesAlive = this.enemies.some((c) => c.hp > 0);

    if (!enemiesAlive) {
      const result = { outcome: 'victory', log: 'Victory!' };
      this._log(result.log);
      this._onEnd?.(result);
      return result;
    }
    if (!partyAlive) {
      const result = { outcome: 'defeat', log: 'Defeat...' };
      this._log(result.log);
      this._onEnd?.(result);
      return result;
    }
    return { outcome: 'ongoing', log: '' };
  }

  /**
   * @private Append to log and notify callback.
   * @param {string} msg
   */
  _log(msg) {
    this.log.push(msg);
    this._onAction?.(msg);
  }

  /**
   * @private Random integer in [min, max] inclusive.
   * @param {number} min
   * @param {number} max
   * @returns {number}
   */
  _randInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}
