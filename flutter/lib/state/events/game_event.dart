import 'package:equatable/equatable.dart';

enum GameScene { title, campus, combat, dialogue, minigame, gameOver }

class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final bool loadSave;
  const GameStarted({this.loadSave = false});
  @override
  List<Object?> get props => [loadSave];
}

class SceneChanged extends GameEvent {
  final GameScene scene;
  final Map<String, dynamic>? data;
  const SceneChanged(this.scene, {this.data});
  @override
  List<Object?> get props => [scene, data];
}

class WeekAdvanced extends GameEvent {
  const WeekAdvanced();
  @override
  List<Object?> get props => [];
}

class ActionCompleted extends GameEvent {
  final String actionId;
  final Map<String, int> statGains;
  final int energyCost;
  final int? sanityCost;
  const ActionCompleted({
    required this.actionId,
    this.statGains = const {},
    this.energyCost = 0,
    this.sanityCost,
  });
  @override
  List<Object?> get props => [actionId, statGains, energyCost, sanityCost];
}

class ResourceModified extends GameEvent {
  final int? goldDelta;
  final int? energyDelta;
  final int? sanityDelta;
  const ResourceModified({this.goldDelta, this.energyDelta, this.sanityDelta});
  @override
  List<Object?> get props => [goldDelta, energyDelta, sanityDelta];
}

class FlagSet extends GameEvent {
  final String flag;
  final bool value;
  const FlagSet(this.flag, {this.value = true});
  @override
  List<Object?> get props => [flag, value];
}

class RelationshipModified extends GameEvent {
  final String characterId;
  final int delta;
  const RelationshipModified(this.characterId, this.delta);
  @override
  List<Object?> get props => [characterId, delta];
}

class NotificationShown extends GameEvent {
  final String message;
  final String type;
  const NotificationShown(this.message, {this.type = 'info'});
  @override
  List<Object?> get props => [message, type];
}

class GameSaved extends GameEvent {
  const GameSaved();
  @override
  List<Object?> get props => [];
}

class GameLoaded extends GameEvent {
  const GameLoaded();
  @override
  List<Object?> get props => [];
}

class GameNotification {
  final String message;
  final String type;
  final double alpha;

  const GameNotification({
    required this.message,
    this.type = 'info',
    this.alpha = 1.0,
  });
}
