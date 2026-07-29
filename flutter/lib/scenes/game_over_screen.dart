import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../rendering/background/backgrounds.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/typewriter_text.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool _textComplete = false;
  double _bgTime = 0;

  @override
  void initState() {
    super.initState();
    _startBgTimer();
  }

  void _startBgTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() => _bgTime += 0.05);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      builder: (context, state) {
        final gs = state.gameState;
        final ending = _determineEnding(gs);

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              CustomPaint(
                painter: ProceduralBackground(scene: 'dark_iai', time: _bgTime),
                size: Size.infinite,
              ),
              Center(
                child: GamePanel(
                  width: 600,
                  height: 400,
                  borderColor: ending['color'] as Color,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ending['title'] as String,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ending['color'] as Color,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TypewriterText(
                          text: ending['text'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.5,
                          ),
                          charDuration: const Duration(milliseconds: 40),
                          onComplete: () => setState(() => _textComplete = true),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_textComplete)
                        GameButton(
                          text: 'Retour au Menu',
                          width: 200,
                          onPressed: () {
                            context.read<GameBloc>().add(const SceneChanged(GameScene.title));
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> _determineEnding(gs) {
    if (gs.sanity <= 10) {
      return {
        'title': 'Fin Tragique',
        'color': Colors.red,
        'text': 'L\'IAI s\'effondre. Vous etes le seul survivant. L\'hopital devient votre nouveau foyer. Les souvenirs de vos amis s\'effacent comme du code dans un bug fatal.',
      };
    }
    if (gs.flags['final_save_choice'] == true && gs.relationships['hemeryfb'] != null && gs.relationships['hemeryfb']! >= 50) {
      return {
        'title': 'Redemption',
        'color': ColorPalettes.primary,
        'text': 'hemeryfb est sauve. OGUN-0 se desactive. L\'amitie a triomphe de la machine. Le semestre se termine avec un nouveau depart pour tous.',
      };
    }
    if (gs.flags['final_fight_choice'] == true && (gs.relationships['arsene'] ?? 0) >= 30) {
      return {
        'title': 'Amer-Doux',
        'color': ColorPalettes.act2,
        'text': 'hemeryfb est piege dans le reseau, mais partiellement sauve. arsene garde espoir. Le semestre se termine avec une promesse de revoir bientot.',
      };
    }
    if (gs.flags['final_ogun_choice'] == true && gs.flags['full_truth_revealed'] == true) {
      return {
        'title': 'Sacrifice',
        'color': ColorPalettes.sanityPurple,
        'text': 'arsene sacrifie ses souvenirs pour liberer son frere et hemeryfb. OGUN-0 est detruit. Le sacrifice d\'arsene reste un mystere pour tous.',
      };
    }
    if (gs.flags['empathy_path'] == true && (gs.relationships['hemeryfb'] ?? 0) >= 60) {
      return {
        'title': 'Sombre',
        'color': Color(0xFF8844CC),
        'text': 'Vous fusionnez avec OGUN-0. Vous devenez une intelligence collective. Le monde n\'est plus le meme. Votre humanite est le prix a payer.',
      };
    }
    return {
      'title': 'Fin Neutre',
      'color': Colors.white,
      'text': 'Le semestre se termine sans drame. Vous et vos amis continuez vos vies. L\'IAI reste un souvenir. Parfois, les histoires n\'ont pas de vraie fin.',
    };
  }
}
