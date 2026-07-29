class Skill {
  final String id;
  final String name;
  final String description;
  final int mpCost;
  final int cooldown;
  final SkillType type;
  final int power;
  final String targetType;
  final int levelRequired;

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.mpCost,
    this.cooldown = 0,
    required this.type,
    this.power = 0,
    this.targetType = 'enemy',
    this.levelRequired = 1,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        mpCost: json['mpCost'] as int,
        cooldown: json['cooldown'] as int? ?? 0,
        type: SkillType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => SkillType.attack,
        ),
        power: json['power'] as int? ?? 0,
        targetType: json['targetType'] as String? ?? 'enemy',
        levelRequired: json['levelRequired'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'mpCost': mpCost,
        'cooldown': cooldown,
        'type': type.name,
        'power': power,
        'targetType': targetType,
        'levelRequired': levelRequired,
      };
}

enum SkillType { attack, heal, defense, support, special, debuff }
