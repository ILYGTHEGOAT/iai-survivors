/**
 * Weekly schedule management.
 *
 * Tracks the in-game day/time and triggers events when scheduled
 * activities or deadlines arrive.
 *
 * Time flows in fixed increments (e.g., 1 game-hour = 1 real minute, configurable).
 */

/**
 * @typedef {Object} ScheduleEvent
 * @property {string} id
 * @property {string} title
 * @property {number} day - 1-indexed day of the week (1=Mon … 7=Sun)
 * @property {number} hour - 0-23
 * @property {number} [duration=1] - hours
 * @property {function} [onTrigger] - callback when the event fires
 * @property {boolean} [_fired] - internal flag
 */

const DAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

export class Schedule {
  constructor() {
    /** Current day (1-7) */
    this.day = 1;
    /** Current hour (0-23, fractional for sub-hour precision) */
    this.hour = 8;
    /** Minutes per real second (time acceleration) */
    this.minutesPerSecond = 2;
    /** Whether the schedule is paused */
    this.paused = false;
    /** @type {ScheduleEvent[]} */
    this.events = [];
    /** Callback fired on new day: (dayNumber) => void */
    this.onDayChange = null;
    /** Callback fired on event trigger: (event) => void */
    this.onEventTrigger = null;
  }

  /**
   * Register a scheduled event.
   * @param {ScheduleEvent} event
   * @returns {ScheduleEvent}
   */
  addEvent(event) {
    event._fired = false;
    this.events.push(event);
    return event;
  }

  /**
   * Remove an event by id.
   * @param {string} id
   */
  removeEvent(id) {
    this.events = this.events.filter((e) => e.id !== id);
  }

  /** Clear all events */
  clearEvents() {
    this.events = [];
  }

  /**
   * Advance time.
   * @param {number} dt - seconds
   */
  update(dt) {
    if (this.paused) return;

    const minutesElapsed = this.minutesPerSecond * dt;
    const hoursElapsed = minutesElapsed / 60;

    const prevDay = this.day;
    this.hour += hoursElapsed;

    // Wrap hours into next day(s)
    while (this.hour >= 24) {
      this.hour -= 24;
      this.day++;
      if (this.day > 7) {
        this.day = 1;
      }
    }

    if (this.day !== prevDay) {
      this.onDayChange?.(this.day);
      // Reset _fired flags for the new day
      for (const ev of this.events) {
        if (ev.day !== this.day) ev._fired = false;
      }
    }

    this._checkEvents();
  }

  /** @private Check if any events should fire now */
  _checkEvents() {
    for (const ev of this.events) {
      if (ev._fired) continue;
      if (ev.day !== this.day) continue;
      if (this.hour >= ev.hour && this.hour < ev.hour + (ev.duration ?? 1)) {
        ev._fired = true;
        this.onEventTrigger?.(ev);
        ev.onTrigger?.();
      }
    }
  }

  /**
   * Get the current day name.
   * @returns {string}
   */
  getDayName() {
    return DAYS[this.day - 1] ?? '???';
  }

  /**
   * Get a formatted time string (e.g., "08:30").
   * @returns {string}
   */
  getTimeString() {
    const h = Math.floor(this.hour).toString().padStart(2, '0');
    const m = Math.floor((this.hour % 1) * 60).toString().padStart(2, '0');
    return `${h}:${m}`;
  }

  /**
   * Get the full display string (e.g., "Wed 14:05").
   * @returns {string}
   */
  getDisplayString() {
    return `${this.getDayName()} ${this.getTimeString()}`;
  }

  /**
   * Set time directly.
   * @param {number} day - 1-7
   * @param {number} hour - 0-23
   */
  setTime(day, hour) {
    this.day = Math.max(1, Math.min(7, day));
    this.hour = Math.max(0, Math.min(23.99, hour));
    // Reset fired flags
    for (const ev of this.events) ev._fired = false;
  }

  /** @returns {Object} Serializable snapshot */
  serialize() {
    return { day: this.day, hour: this.hour };
  }

  /**
   * Restore from a snapshot.
   * @param {{ day: number, hour: number }} data
   */
  deserialize(data) {
    this.day = data.day ?? 1;
    this.hour = data.hour ?? 8;
  }
}
