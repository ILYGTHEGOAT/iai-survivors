import 'package:equatable/equatable.dart';
import '../../data/models/game_state.dart';
import '../events/game_event.dart';

class GameBlocState extends Equatable {
  final GameScene currentScene;
  final Map<String, dynamic>? sceneData;
  final GameState gameState;
  final List<GameNotification> notifications;
  final bool isLoading;

  const GameBlocState({
    this.currentScene = GameScene.title,
    this.sceneData,
    this.gameState = const GameState(),
    this.notifications = const [],
    this.isLoading = false,
  });

  GameBlocState copyWith({
    GameScene? currentScene,
    Map<String, dynamic>? sceneData,
    GameState? gameState,
    List<GameNotification>? notifications,
    bool? isLoading,
  }) =>
      GameBlocState(
        currentScene: currentScene ?? this.currentScene,
        sceneData: sceneData ?? this.sceneData,
        gameState: gameState ?? this.gameState,
        notifications: notifications ?? this.notifications,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [currentScene, sceneData, gameState, notifications, isLoading];
}
