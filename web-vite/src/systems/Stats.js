/**
 * Character stats system.
 *
 * Each character has a set of core stats and derived values.
 * Stats can be modified by temporary buffs or permanent upgrades.
 */

/**
 * @typedef {Object} StatBlock
 * @property {number} hp
 * @property {number} maxHp
 * @property {number} attack
 * @property {number} defense
 * @property {number} speed
 * @property {number} xp
 * @property {number} level
 */

/**
 * @typedef {Object} Buff
 * @property {string} id
 * @property {string} stat - stat key to modify
 * @property {number} amount - flat modifier (can be negative)
 * @property {number} turnsRemaining - -1 = permanent until removed
 */

/** Default base stats for a new character */
const DEFAULT_STATS = { hp: 100, maxHp: 100, attack: 10, defense: 5, speed: 10, xp: 0, level: 1 };

/** XP thresholds per level (index = level, value = xp needed for that level) */
const XP_TABLE = [0, 0, 100, 250, 500, 850, 1300, 1900, 2700, 3800, 5200];

export class Stats {
  /**
   * @param {string} name
   * @param {Partial<StatBlock>} [overrides]
   */
  constructor(name, overrides = {}) {
    this.name = name;
    /** @type {StatBlock} */
    this.base = { ...DEFAULT_STATS, ...overrides };
    /** @type {Buff[]} */
    this.buffs = [];
  }

  /**
   * Get the effective value of a stat after applying buffs.
   * @param {string} stat
   * @returns {number}
   */
  get(stat) {
    const base = this.base[stat] ?? 0;
    const bonus = this.buffs
      .filter((b) => b.stat === stat)
      .reduce((sum, b) => sum + b.amount, 0);
    return base + bonus;
  }

  /**
   * Set a base stat value.
   * @param {string} stat
   * @param {number} value
   */
  set(stat, value) {
    if (stat in this.base) this.base[stat] = value;
  }

  /**
   * Modify a base stat by a delta.
   * @param {string} stat
   * @param {number} delta
   */
  modify(stat, delta) {
    if (stat in this.base) {
      this.base[stat] += delta;
    }
  }

  /**
   * Apply a temporary or permanent buff.
   * @param {Buff} buff
   */
  addBuff(buff) {
    this.buffs.push({ ...buff });
    // Immediately adjust HP if maxHp changed
    if (buff.stat === 'maxHp' && buff.amount > 0) {
      this.base.hp = Math.min(this.base.hp + buff.amount, this.get('maxHp'));
    }
  }

  /**
   * Remove a buff by id.
   * @param {string} id
   */
  removeBuff(id) {
    const idx = this.buffs.findIndex((b) => b.id === id);
    if (idx === -1) return;
    const removed = this.buffs.splice(idx, 1)[0];
    if (removed.stat === 'maxHp') {
      this.base.hp = Math.min(this.base.hp, this.get('maxHp'));
    }
  }

  /** Decrement all temporary buff timers and remove expired ones */
  tickBuffs() {
    this.buffs = this.buffs.filter((b) => {
      if (b.turnsRemaining === -1) return true;
      b.turnsRemaining--;
      return b.turnsRemaining > 0;
    });
  }

  /**
   * Apply damage to HP (after defense).
   * @param {number} rawDamage
   * @returns {number} actual damage dealt
   */
  takeDamage(rawDamage) {
    const actual = Math.max(1, rawDamage - this.get('defense'));
    this.base.hp = Math.max(0, this.base.hp - actual);
    return actual;
  }

  /**
   * Heal HP, capped at maxHp.
   * @param {number} amount
   * @returns {number} actual healing done
   */
  heal(amount) {
    const max = this.get('maxHp');
    const actual = Math.min(amount, max - this.base.hp);
    this.base.hp += actual;
    return actual;
  }

  /** @returns {boolean} */
  isAlive() {
    return this.base.hp > 0;
  }

  /**
   * Grant XP and check for level-up.
   * @param {number} amount
   * @returns {boolean} true if levelled up
   */
  grantXp(amount) {
    this.base.xp += amount;
    const nextLevelXp = XP_TABLE[this.base.level + 1];
    if (nextLevelXp !== undefined && this.base.xp >= nextLevelXp) {
      this.base.level++;
      this._onLevelUp();
      return true;
    }
    return false;
  }

  /** @private Called when the character levels up */
  _onLevelUp() {
    this.base.maxHp += 10;
    this.base.hp = this.get('maxHp');
    this.base.attack += 2;
    this.base.defense += 1;
    this.base.speed += 1;
  }

  /**
   * Get XP needed for the next level.
   * @returns {number|null}
   */
  xpToNextLevel() {
    const next = XP_TABLE[this.base.level + 1];
    return next !== undefined ? next - this.base.xp : null;
  }

  /** @returns {Object} Serializable snapshot */
  serialize() {
    return {
      name: this.name,
      base: { ...this.base },
      buffs: this.buffs.map((b) => ({ ...b }))
    };
  }

  /**
   * Restore from a snapshot.
   * @param {Object} data
   */
  deserialize(data) {
    this.name = data.name ?? this.name;
    Object.assign(this.base, data.base);
    this.buffs = (data.buffs ?? []).map((b) => ({ ...b }));
  }
}
