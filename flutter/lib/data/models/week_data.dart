class WeekData {
  final int week;
  final int act;
  final String title;
  final String description;
  final List<String> objectives;
  final String? dialogueId;
  final String? bossId;
  final String? minigameId;
  final String? bgScene;
  final int energyCost;
  final int sanityCost;
  final List<WeekAction> availableActions;
  const WeekData({
    required this.week,
    required this.act,
    required this.title,
    required this.description,
    this.objectives = const [],
    this.dialogueId,
    this.bossId,
    this.minigameId,
    this.bgScene = 'campus_day',
    this.energyCost = 0,
    this.sanityCost = 0,
    this.availableActions = const [],
  });

  factory WeekData.fromJson(Map<String, dynamic> json) => WeekData(
        week: json['week'] as int,
        act: json['act'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        objectives: (json['objectives'] as List?)?.cast<String>() ?? [],
        dialogueId: json['dialogueId'] as String?,
        bossId: json['bossId'] as String?,
        minigameId: json['minigameId'] as String?,
        bgScene: json['bgScene'] as String? ?? 'campus_day',
        energyCost: json['energyCost'] as int? ?? 0,
        sanityCost: json['sanityCost'] as int? ?? 0,
        availableActions: (json['availableActions'] as List?)
                ?.map((a) => WeekAction.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'week': week,
        'act': act,
        'title': title,
        'description': description,
        'objectives': objectives,
        'dialogueId': dialogueId,
        'bossId': bossId,
        'minigameId': minigameId,
        'bgScene': bgScene,
        'energyCost': energyCost,
        'sanityCost': sanityCost,
      };
}

class WeekAction {
  final String id;
  final String text;
  final String description;
  final String timeSlot;
  final Map<String, int> statGains;
  final int energyCost;
  final int? sanityCost;
  final int? relationshipGain;

  const WeekAction({
    required this.id,
    required this.text,
    required this.description,
    required this.timeSlot,
    this.statGains = const {},
    this.energyCost = 0,
    this.sanityCost,
    this.relationshipGain,
  });

  factory WeekAction.fromJson(Map<String, dynamic> json) => WeekAction(
        id: json['id'] as String,
        text: json['text'] as String,
        description: json['description'] as String,
        timeSlot: json['timeSlot'] as String,
        statGains: Map<String, int>.from(json['statGains'] as Map? ?? {}),
        energyCost: json['energyCost'] as int? ?? 0,
        sanityCost: json['sanityCost'] as int?,
        relationshipGain: json['relationshipGain'] as int?,
      );
}
