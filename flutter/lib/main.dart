import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'state/blocs/game_bloc.dart';
import 'state/events/game_event.dart';
import 'state/states/game_bloc_state.dart';
import 'scenes/title_screen.dart';
import 'scenes/campus_screen.dart';
import 'scenes/combat_screen.dart';
import 'scenes/dialogue_screen.dart';
import 'scenes/minigame_screen.dart';
import 'scenes/game_over_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final gameBloc = GameBloc();
  await gameBloc.init();

  runApp(MyApp(gameBloc: gameBloc));
}

class MyApp extends StatelessWidget {
  final GameBloc gameBloc;

  const MyApp({super.key, required this.gameBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: gameBloc,
      child: MaterialApp(
        title: 'IA Survivors',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'monospace',
        ),
        home: const GameRouter(),
      ),
    );
  }
}

class GameRouter extends StatelessWidget {
  const GameRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      builder: (context, state) {
        Widget screen;
        switch (state.currentScene) {
          case GameScene.title:
            screen = const TitleScreen();
            break;
          case GameScene.campus:
            screen = const CampusScreen();
            break;
          case GameScene.combat:
            screen = const CombatScreen();
            break;
          case GameScene.dialogue:
            screen = const DialogueScreen();
            break;
          case GameScene.minigame:
            screen = const MinigameScreen();
            break;
          case GameScene.gameOver:
            screen = const GameOverScreen();
            break;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: screen,
        );
      },
    );
  }
}
