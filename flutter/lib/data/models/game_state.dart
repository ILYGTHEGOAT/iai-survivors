import 'party_member.dart';

class GameState {
  final int week;
  final int act;
  final int day;
  final int gold;
  final int energy;
  final int sanity;
  final Map<String, int> playerStats;
  final List<PartyMember> party;
  final Map<String, bool> flags;
  final Map<String, int> relationships;
  final int hemeryfbTrust;
  final bool darkIaiAccess;
  final bool ogun0Awakened;
  final int virusProgress;
  final List<String> questLog;
  final List<String> completedActions;

  const GameState({
    this.week = 1,
    this.act = 1,
    this.day = 1,
    this.gold = 50,
    this.energy = 100,
    this.sanity = 100,
    this.playerStats = const {},
    this.party = const [],
    this.flags = const {},
    this.relationships = const {},
    this.hemeryfbTrust = 0,
    this.darkIaiAccess = false,
    this.ogun0Awakened = false,
    this.virusProgress = 0,
    this.questLog = const [],
    this.completedActions = const [],
  });

  GameState copyWith({
    int? week,
    int? act,
    int? day,
    int? gold,
    int? energy,
    int? sanity,
    Map<String, int>? playerStats,
    List<PartyMember>? party,
    Map<String, bool>? flags,
    Map<String, int>? relationships,
    int? hemeryfbTrust,
    bool? darkIaiAccess,
    bool? ogun0Awakened,
    int? virusProgress,
    List<String>? questLog,
    List<String>? completedActions,
  }) =>
      GameState(
        week: week ?? this.week,
        act: act ?? this.act,
        day: day ?? this.day,
        gold: gold ?? this.gold,
        energy: energy ?? this.energy,
        sanity: sanity ?? this.sanity,
        playerStats: playerStats ?? this.playerStats,
        party: party ?? this.party,
        flags: flags ?? this.flags,
        relationships: relationships ?? this.relationships,
        hemeryfbTrust: hemeryfbTrust ?? this.hemeryfbTrust,
        darkIaiAccess: darkIaiAccess ?? this.darkIaiAccess,
        ogun0Awakened: ogun0Awakened ?? this.ogun0Awakened,
        virusProgress: virusProgress ?? this.virusProgress,
        questLog: questLog ?? this.questLog,
        completedActions: completedActions ?? this.completedActions,
      );

  Map<String, dynamic> toJson() => {
        'week': week,
        'act': act,
        'day': day,
        'gold': gold,
        'energy': energy,
        'sanity': sanity,
        'playerStats': playerStats,
        'party': party.map((p) => p.toJson()).toList(),
        'flags': flags,
        'relationships': relationships,
        'hemeryfbTrust': hemeryfbTrust,
        'darkIaiAccess': darkIaiAccess,
        'ogun0Awakened': ogun0Awakened,
        'virusProgress': virusProgress,
        'questLog': questLog,
        'completedActions': completedActions,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        week: json['week'] as int? ?? 1,
        act: json['act'] as int? ?? 1,
        day: json['day'] as int? ?? 1,
        gold: json['gold'] as int? ?? 50,
        energy: json['energy'] as int? ?? 100,
        sanity: json['sanity'] as int? ?? 100,
        playerStats: Map<String, int>.from(json['playerStats'] as Map? ?? {}),
        party: (json['party'] as List?)
                ?.map((p) => PartyMember.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
        flags: Map<String, bool>.from(json['flags'] as Map? ?? {}),
        relationships: Map<String, int>.from(json['relationships'] as Map? ?? {}),
        hemeryfbTrust: json['hemeryfbTrust'] as int? ?? 0,
        darkIaiAccess: json['darkIaiAccess'] as bool? ?? false,
        ogun0Awakened: json['ogun0Awakened'] as bool? ?? false,
        virusProgress: json['virusProgress'] as int? ?? 0,
        questLog: (json['questLog'] as List?)?.cast<String>() ?? [],
        completedActions: (json['completedActions'] as List?)?.cast<String>() ?? [],
      );
}
