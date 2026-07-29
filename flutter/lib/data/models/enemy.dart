import 'skill.dart';
import 'party_member.dart';

class Enemy {
  final String id;
  final String name;
  final int maxHp;
  int hp;
  final int baseAttack;
  final int baseDefense;
  final int baseSpeed;
  final bool isBoss;
  final List<BossPhase> phases;
  int currentPhase;
  final List<Skill> skills;
  final List<Debuff> debuffs;

  Enemy({
    required this.id,
    required this.name,
    required this.maxHp,
    int? hp,
    required this.baseAttack,
    required this.baseDefense,
    required this.baseSpeed,
    this.isBoss = false,
    List<BossPhase>? phases,
    this.currentPhase = 0,
    List<Skill>? skills,
    List<Debuff>? debuffs,
  })  : hp = hp ?? maxHp,
        phases = phases ?? const [],
        skills = skills ?? const [],
        debuffs = debuffs ?? [];

  bool get isAlive => hp > 0;
  double get hpPercent => maxHp > 0 ? hp / maxHp : 0;

  int get attack => baseAttack + (currentPhase > 0 ? phases[currentPhase - 1].attackBonus : 0);
  int get defense => baseDefense + (currentPhase > 0 ? phases[currentPhase - 1].defenseBonus : 0);
  int get speed => baseSpeed + (currentPhase > 0 ? phases[currentPhase - 1].speedBonus : 0);

  void takeDamage(int damage) {
    hp = (hp - damage).clamp(0, maxHp);
    checkPhaseTransition();
  }

  void checkPhaseTransition() {
    if (phases.isEmpty) return;
    final hpPercent = hp / maxHp;
    for (int i = phases.length - 1; i >= 0; i--) {
      if (hpPercent <= phases[i].hpThreshold && currentPhase <= i) {
        currentPhase = i + 1;
        break;
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'maxHp': maxHp,
        'hp': hp,
        'baseAttack': baseAttack,
        'baseDefense': baseDefense,
        'baseSpeed': baseSpeed,
        'isBoss': isBoss,
        'currentPhase': currentPhase,
        'skills': skills.map((s) => s.toJson()).toList(),
      };

  factory Enemy.fromJson(Map<String, dynamic> json) => Enemy(
        id: json['id'] as String,
        name: json['name'] as String,
        maxHp: json['maxHp'] as int,
        hp: json['hp'] as int?,
        baseAttack: json['baseAttack'] as int,
        baseDefense: json['baseDefense'] as int,
        baseSpeed: json['baseSpeed'] as int,
        isBoss: json['isBoss'] as bool? ?? false,
        currentPhase: json['currentPhase'] as int? ?? 0,
        skills: (json['skills'] as List?)
                ?.map((s) => Skill.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class BossPhase {
  final double hpThreshold;
  final int attackBonus;
  final int defenseBonus;
  final int speedBonus;

  const BossPhase({
    required this.hpThreshold,
    this.attackBonus = 0,
    this.defenseBonus = 0,
    this.speedBonus = 0,
  });
}
