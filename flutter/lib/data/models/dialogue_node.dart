class DialogueNode {
  final String id;
  final String speaker;
  final String text;
  final String? portrait;
  final String? next;
  final List<DialogueChoice>? choices;
  final String? startCombat;
  final String? setFlag;
  final DialogueEffects? effects;

  const DialogueNode({
    required this.id,
    required this.speaker,
    required this.text,
    this.portrait,
    this.next,
    this.choices,
    this.startCombat,
    this.setFlag,
    this.effects,
  });

  bool get hasNext => next != null;
  bool get hasChoices => choices != null && choices!.isNotEmpty;
  bool get isTerminal => next == null && !hasChoices;
  bool get triggersCombat => startCombat != null;

  factory DialogueNode.fromJson(Map<String, dynamic> json) => DialogueNode(
        id: json['id'] as String,
        speaker: json['speaker'] as String? ?? 'narrator',
        text: json['text'] as String,
        portrait: json['portrait'] as String?,
        next: json['next'] as String?,
        choices: (json['choices'] as List?)
            ?.map((c) => DialogueChoice.fromJson(c as Map<String, dynamic>))
            .toList(),
        startCombat: json['startCombat'] as String?,
        setFlag: json['setFlag'] as String?,
        effects: json['effects'] != null
            ? DialogueEffects.fromJson(json['effects'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'speaker': speaker,
        'text': text,
        'portrait': portrait,
        'next': next,
        'choices': choices?.map((c) => c.toJson()).toList(),
        'startCombat': startCombat,
        'setFlag': setFlag,
        'effects': effects?.toJson(),
      };
}

class DialogueChoice {
  final String text;
  final String next;
  final DialogueEffects? effects;

  const DialogueChoice({
    required this.text,
    required this.next,
    this.effects,
  });

  factory DialogueChoice.fromJson(Map<String, dynamic> json) => DialogueChoice(
        text: json['text'] as String,
        next: json['next'] as String,
        effects: json['effects'] != null
            ? DialogueEffects.fromJson(json['effects'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'next': next,
        'effects': effects?.toJson(),
      };
}

class DialogueEffects {
  final Map<String, int>? stat;
  final int? groupRelation;
  final int? hemeryfbRelation;
  final String? flag;
  final int? sanityEffect;
  final int? energyEffect;
  final String? combatBuff;

  const DialogueEffects({
    this.stat,
    this.groupRelation,
    this.hemeryfbRelation,
    this.flag,
    this.sanityEffect,
    this.energyEffect,
    this.combatBuff,
  });

  factory DialogueEffects.fromJson(Map<String, dynamic> json) => DialogueEffects(
        stat: json['stat'] != null
            ? Map<String, int>.from(json['stat'] as Map)
            : null,
        groupRelation: json['groupRelation'] as int?,
        hemeryfbRelation: json['hemeryfbRelation'] as int?,
        flag: json['flag'] as String?,
        sanityEffect: json['sanityEffect'] as int?,
        energyEffect: json['energyEffect'] as int?,
        combatBuff: json['combatBuff'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (stat != null) 'stat': stat,
        if (groupRelation != null) 'groupRelation': groupRelation,
        if (hemeryfbRelation != null) 'hemeryfbRelation': hemeryfbRelation,
        if (flag != null) 'flag': flag,
        if (sanityEffect != null) 'sanityEffect': sanityEffect,
        if (energyEffect != null) 'energyEffect': energyEffect,
        if (combatBuff != null) 'combatBuff': combatBuff,
      };
}
