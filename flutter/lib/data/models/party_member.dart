import 'skill.dart';

class PartyMember {
  final String id;
  final String name;
  final String title;
  final int maxHp;
  final int maxMp;
  int hp;
  int mp;
  int xp;
  int level;
  final Map<String, int> stats;
  final List<Skill> skills;
  final List<Buff> buffs;
  final List<Debuff> debuffs;
  final String colorHex;

  PartyMember({
    required this.id,
    required this.name,
    required this.title,
    required this.maxHp,
    required this.maxMp,
    int? hp,
    int? mp,
    this.xp = 0,
    this.level = 1,
    Map<String, int>? stats,
    List<Skill>? skills,
    List<Buff>? buffs,
    List<Debuff>? debuffs,
    this.colorHex = '#FFFFFF',
  })  : hp = hp ?? maxHp,
        mp = mp ?? maxMp,
        stats = stats ?? const {},
        skills = skills ?? const [],
        buffs = buffs ?? [],
        debuffs = debuffs ?? [];

  int get attack => (stats['coding'] ?? 5) * 3 + (stats['logic'] ?? 5) * 2;
  int get defense => (stats['endurance'] ?? 5) * 2;
  int get speed => (stats['logic'] ?? 5) + (stats['creativity'] ?? 5);

  int get xpToNext => level * 100;
  bool get isAlive => hp > 0;
  double get hpPercent => maxHp > 0 ? hp / maxHp : 0;
  double get mpPercent => maxMp > 0 ? mp / maxMp : 0;

  void takeDamage(int damage) {
    final shield = buffs.where((b) => b.type == BuffType.shield).fold(0, (sum, b) => sum + b.value);
    final absorbed = damage <= shield ? damage : shield;
    final remaining = damage - absorbed;
    buffs.removeWhere((b) => b.type == BuffType.shield && absorbed > 0);
    hp = (hp - remaining).clamp(0, maxHp);
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, maxHp);
  }

  void useMp(int amount) {
    mp = (mp - amount).clamp(0, maxMp);
  }

  void gainXp(int amount) {
    xp += amount;
    while (xp >= xpToNext) {
      xp -= xpToNext;
      level++;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'maxHp': maxHp,
        'maxMp': maxMp,
        'hp': hp,
        'mp': mp,
        'xp': xp,
        'level': level,
        'stats': stats,
        'skills': skills.map((s) => s.toJson()).toList(),
      };

  factory PartyMember.fromJson(Map<String, dynamic> json) => PartyMember(
        id: json['id'] as String,
        name: json['name'] as String,
        title: json['title'] as String,
        maxHp: json['maxHp'] as int,
        maxMp: json['maxMp'] as int,
        hp: json['hp'] as int?,
        mp: json['mp'] as int?,
        xp: json['xp'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        stats: Map<String, int>.from(json['stats'] as Map? ?? {}),
        skills: (json['skills'] as List?)
                ?.map((s) => Skill.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class Buff {
  final BuffType type;
  final int value;
  int remainingTurns;

  Buff({required this.type, required this.value, required this.remainingTurns});

  bool get isActive => remainingTurns > 0;
  void tick() => remainingTurns--;
}

class Debuff {
  final DebuffType type;
  final int value;
  int remainingTurns;

  Debuff({required this.type, required this.value, required this.remainingTurns});

  bool get isActive => remainingTurns > 0;
  void tick() => remainingTurns--;
}

enum BuffType { attackBoost, shield, defenseBoost, speedBoost }
enum DebuffType { defenseDown, dot, stun, confuse }
