/**
 * Persistent save/load system backed by localStorage with JSON export/import.
 */
export class Storage {
  /** @param {string} namespace - prefix for localStorage keys */
  constructor(namespace = 'iai_survivors') {
    this.ns = namespace;
    /** @type {Object.<string, any>} */
    this._cache = {};
    /** Auto-save interval id (ms) */
    this._autoSaveInterval = null;
  }

  /** Hydrate cache from localStorage */
  init() {
    try {
      const raw = localStorage.getItem(`${this.ns}:data`);
      if (raw) this._cache = JSON.parse(raw);
    } catch {
      this._cache = {};
    }
  }

  /**
   * Get a saved value by key.
   * @param {string} key
   * @param {*} [defaultValue]
   * @returns {*}
   */
  get(key, defaultValue = undefined) {
    return key in this._cache ? this._cache[key] : defaultValue;
  }

  /**
   * Set a value in the cache (does not persist until save is called).
   * @param {string} key
   * @param {*} value
   */
  set(key, value) {
    this._cache[key] = value;
  }

  /** Persist the current cache to localStorage */
  save() {
    try {
      localStorage.setItem(`${this.ns}:data`, JSON.stringify(this._cache));
    } catch (err) {
      console.error('[Storage] Save failed:', err);
    }
  }

  /** Remove a single key or the entire save */
  clear(key) {
    if (key) {
      delete this._cache[key];
    } else {
      this._cache = {};
      localStorage.removeItem(`${this.ns}:data`);
    }
  }

  /** @returns {string} JSON blob of the full save */
  exportJSON() {
    return JSON.stringify(this._cache, null, 2);
  }

  /**
   * Import a JSON string, replacing the entire save.
   * @param {string} json
   * @returns {boolean} success
   */
  importJSON(json) {
    try {
      const data = JSON.parse(json);
      if (typeof data !== 'object' || data === null) return false;
      this._cache = data;
      this.save();
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Start auto-saving at a fixed interval.
   * @param {number} intervalMs - default 30 000
   */
  startAutoSave(intervalMs = 30_000) {
    this.stopAutoSave();
    this._autoSaveInterval = setInterval(() => this.save(), intervalMs);
  }

  /** Stop auto-saving */
  stopAutoSave() {
    if (this._autoSaveInterval !== null) {
      clearInterval(this._autoSaveInterval);
      this._autoSaveInterval = null;
    }
  }
}
