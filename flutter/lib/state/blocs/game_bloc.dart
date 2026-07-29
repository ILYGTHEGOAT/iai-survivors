import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/repositories/game_data.dart';
import '../events/game_event.dart';
import '../states/game_bloc_state.dart';
import '../../data/models/game_state.dart';
import '../../data/models/party_member.dart';

class GameBloc extends Bloc<GameEvent, GameBlocState> {
  late Box _saveBox;

  GameBloc() : super(const GameBlocState()) {
    on<GameStarted>(_onGameStarted);
    on<SceneChanged>(_onSceneChanged);
    on<WeekAdvanced>(_onWeekAdvanced);
    on<ActionCompleted>(_onActionCompleted);
    on<ResourceModified>(_onResourceModified);
    on<FlagSet>(_onFlagSet);
    on<RelationshipModified>(_onRelationshipModified);
    on<NotificationShown>(_onNotificationShown);
    on<GameSaved>(_onGameSaved);
    on<GameLoaded>(_onGameLoaded);
  }

  Future<void> init() async {
    _saveBox = await Hive.openBox('saves');
  }

  void _onGameStarted(GameStarted event, Emitter<GameBlocState> emit) async {
    emit(state.copyWith(isLoading: true));

    if (event.loadSave) {
      final saved = _saveBox.get('current_save');
      if (saved != null) {
        final json = jsonDecode(saved as String) as Map<String, dynamic>;
        final gameState = GameState.fromJson(json);
        emit(state.copyWith(
          isLoading: false,
          gameState: gameState,
          currentScene: GameScene.campus,
        ));
        return;
      }
    }

    final party = GameData.defaultParty.map((p) => PartyMember(
      id: p.id,
      name: p.name,
      title: p.title,
      maxHp: p.maxHp,
      maxMp: p.maxMp,
      colorHex: p.colorHex,
      stats: Map.from(p.stats),
      skills: List.from(p.skills),
    )).toList();

    final gameState = GameState(
      party: party,
      playerStats: Map.from(GameData.defaultParty.first.stats),
    );

    emit(state.copyWith(
      isLoading: false,
      gameState: gameState,
      currentScene: GameScene.dialogue,
      sceneData: {'dialogueId': 'welcome_speech'},
    ));
  }

  void _onSceneChanged(SceneChanged event, Emitter<GameBlocState> emit) {
    emit(state.copyWith(
      currentScene: event.scene,
      sceneData: event.data,
    ));
  }

  void _onWeekAdvanced(WeekAdvanced event, Emitter<GameBlocState> emit) {
    final gs = state.gameState;
    final newWeek = gs.week + 1;
    final newAct = newWeek <= 5 ? 1 : (newWeek <= 10 ? 2 : 3);

    emit(state.copyWith(
      gameState: gs.copyWith(
        week: newWeek,
        act: newAct,
        energy: (gs.energy + 50).clamp(0, 100),
        sanity: (gs.sanity + 10).clamp(0, 100),
        completedActions: [],
      ),
    ));
  }

  void _onActionCompleted(ActionCompleted event, Emitter<GameBlocState> emit) {
    final gs = state.gameState;
    final newStats = Map<String, int>.from(gs.playerStats);

    event.statGains.forEach((stat, gain) {
      newStats[stat] = (newStats[stat] ?? 5) + gain;
    });

    final newEnergy = (gs.energy - event.energyCost).clamp(0, 100);
    final newSanity = event.sanityCost != null
        ? (gs.sanity - event.sanityCost!).clamp(0, 100)
        : gs.sanity;

    emit(state.copyWith(
      gameState: gs.copyWith(
        playerStats: newStats,
        energy: newEnergy,
        sanity: newSanity,
        completedActions: [...gs.completedActions, event.actionId],
      ),
    ));
  }

  void _onResourceModified(ResourceModified event, Emitter<GameBlocState> emit) {
    final gs = state.gameState;
    emit(state.copyWith(
      gameState: gs.copyWith(
        gold: event.goldDelta != null
            ? (gs.gold + event.goldDelta!).clamp(0, 9999)
            : gs.gold,
        energy: event.energyDelta != null
            ? (gs.energy + event.energyDelta!).clamp(0, 100)
            : gs.energy,
        sanity: event.sanityDelta != null
            ? (gs.sanity + event.sanityDelta!).clamp(0, 100)
            : gs.sanity,
      ),
    ));
  }

  void _onFlagSet(FlagSet event, Emitter<GameBlocState> emit) {
    final gs = state.gameState;
    final newFlags = Map<String, bool>.from(gs.flags);
    newFlags[event.flag] = event.value;
    emit(state.copyWith(gameState: gs.copyWith(flags: newFlags)));
  }

  void _onRelationshipModified(RelationshipModified event, Emitter<GameBlocState> emit) {
    final gs = state.gameState;
    final newRels = Map<String, int>.from(gs.relationships);
    newRels[event.characterId] = (newRels[event.characterId] ?? 0) + event.delta;
    emit(state.copyWith(gameState: gs.copyWith(relationships: newRels)));
  }

  void _onNotificationShown(NotificationShown event, Emitter<GameBlocState> emit) {
    final notification = GameNotification(message: event.message, type: event.type);
    emit(state.copyWith(notifications: [...state.notifications, notification]));
  }

  Future<void> saveGame() async {
    final json = jsonEncode(state.gameState.toJson());
    await _saveBox.put('current_save', json);
  }

  bool get hasSave => _saveBox.containsKey('current_save');

  void _onGameSaved(GameSaved event, Emitter<GameBlocState> emit) async {
    await saveGame();
    add(const NotificationShown('Jeu sauvegarde!', type: 'success'));
  }

  void _onGameLoaded(GameLoaded event, Emitter<GameBlocState> emit) async {
    final saved = _saveBox.get('current_save');
    if (saved != null) {
      try {
        final json = jsonDecode(saved as String) as Map<String, dynamic>;
        final gameState = GameState.fromJson(json);
        emit(state.copyWith(
          gameState: gameState,
          currentScene: GameScene.campus,
        ));
        add(const NotificationShown('Jeu charge!', type: 'success'));
      } catch (e) {
        add(const NotificationShown('Erreur de chargement', type: 'error'));
      }
    } else {
      add(const NotificationShown('Aucune sauvegarde trouvee', type: 'warning'));
    }
  }
}
