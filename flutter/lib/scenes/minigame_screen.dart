import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import 'minigames/sort_puzzle.dart';
import 'minigames/debug_puzzle.dart';
import 'minigames/hack_puzzle.dart';
import 'minigames/pipe_puzzle.dart';

class MinigameScreen extends StatelessWidget {
  const MinigameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      builder: (context, state) {
        final minigameId = state.sceneData?['minigameId'] as String? ?? 'bubble_sort';

        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildMinigame(minigameId, context),
        );
      },
    );
  }

  Widget _buildMinigame(String id, BuildContext context) {
    VoidCallback onComplete = () {
      context.read<GameBloc>().add(const NotificationShown('Minijeu termine! +XP', type: 'success'));
      context.read<GameBloc>().add(const SceneChanged(GameScene.campus));
    };

    VoidCallback onTimeout = () {
      context.read<GameBloc>().add(const NotificationShown('Temps ecoule!', type: 'warning'));
      context.read<GameBloc>().add(const SceneChanged(GameScene.campus));
    };

    switch (id) {
      case 'bubble_sort':
      case 'algo_puzzle':
      case 'code_marathon':
        return SortPuzzle(gameId: id, onComplete: onComplete, onTimeout: onTimeout);
      case 'debug_marathon':
      case 'audio_analysis':
      case 'antidote_code':
        return DebugPuzzle(gameId: id, onComplete: onComplete, onTimeout: onTimeout);
      case 'hack_puzzle':
      case 'decode_puzzle':
      case 'labyrinth_puzzle':
        return HackPuzzle(gameId: id, onComplete: onComplete, onTimeout: onTimeout);
      case 'data_flow':
        return PipePuzzle(onComplete: onComplete, onTimeout: onTimeout);
      default:
        return SortPuzzle(gameId: 'bubble_sort', onComplete: onComplete, onTimeout: onTimeout);
    }
  }
}
