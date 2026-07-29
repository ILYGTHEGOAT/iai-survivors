import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../data/models/dialogue_node.dart';
import '../../data/models/enemy.dart';
import '../../data/repositories/dialogue_data.dart';
import '../../rendering/background/backgrounds.dart';
import '../../rendering/portraits/character_portraits.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';
import '../../widgets/typewriter_text.dart';

class DialogueScreen extends StatefulWidget {
  const DialogueScreen({super.key});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  late List<DialogueNode> dialogueTree;
  DialogueNode? currentNode;
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

  void initDialogue(String dialogueId) {
    dialogueTree = _getDialogueTree(dialogueId);
    currentNode = dialogueTree.isNotEmpty ? dialogueTree.first : null;
    _textComplete = false;
  }

  List<DialogueNode> _getDialogueTree(String id) {
    return DialogueData.allDialogues[id] ?? DialogueData.welcomeSpeech;
  }

  void _advance() {
    if (currentNode == null) return;

    if (!_textComplete) {
      setState(() => _textComplete = true);
      return;
    }

    if (currentNode!.effects?.flag != null) {
      context.read<GameBloc>().add(FlagSet(currentNode!.effects!.flag!));
    }
    if (currentNode!.effects?.groupRelation != null) {
      for (final id in ['laurencium', 'king', 'arsene']) {
        context.read<GameBloc>().add(RelationshipModified(id, currentNode!.effects!.groupRelation!));
      }
    }
    if (currentNode!.effects?.sanityEffect != null) {
      context.read<GameBloc>().add(ResourceModified(sanityDelta: currentNode!.effects!.sanityEffect));
    }
    if (currentNode!.effects?.energyEffect != null) {
      context.read<GameBloc>().add(ResourceModified(energyDelta: currentNode!.effects!.energyEffect));
    }

    if (currentNode!.triggersCombat) {
      final enemy = _getEnemy(currentNode!.startCombat!);
      context.read<GameBloc>().add(SceneChanged(GameScene.combat, data: {
        'enemies': [enemy],
      }));
      return;
    }

    if (currentNode!.hasNext) {
      final nextNode = dialogueTree.firstWhere(
        (n) => n.id == currentNode!.next,
        orElse: () => currentNode!,
      );
      setState(() {
        currentNode = nextNode;
        _textComplete = false;
      });
    } else if (currentNode!.isTerminal) {
      context.read<GameBloc>().add(const SceneChanged(GameScene.campus));
    }
  }

  Enemy _getEnemy(String id) {
    final enemies = [
      Enemy(id: 'algo_incompris', name: 'Algorithme Incompris', maxHp: 200, baseAttack: 22, baseDefense: 12, baseSpeed: 8, isBoss: true, phases: [
        BossPhase(hpThreshold: 0.7, attackBonus: 5),
        BossPhase(hpThreshold: 0.4, attackBonus: 10, defenseBonus: 5),
      ]),
      Enemy(id: 'crash_memoire', name: 'Crash Memoire', maxHp: 350, baseAttack: 28, baseDefense: 15, baseSpeed: 10, isBoss: true, phases: [
        BossPhase(hpThreshold: 0.7, attackBonus: 8),
        BossPhase(hpThreshold: 0.4, attackBonus: 15, defenseBonus: 8),
        BossPhase(hpThreshold: 0.15, attackBonus: 20, defenseBonus: 12, speedBonus: 5),
      ]),
      Enemy(id: 'ogun0_hemeryfb', name: 'OGUN-0 // hemeryfb', maxHp: 500, baseAttack: 35, baseDefense: 20, baseSpeed: 12, isBoss: true, phases: [
        BossPhase(hpThreshold: 0.7, attackBonus: 10, defenseBonus: 5),
        BossPhase(hpThreshold: 0.4, attackBonus: 20, defenseBonus: 10, speedBonus: 5),
        BossPhase(hpThreshold: 0.15, attackBonus: 30, defenseBonus: 15, speedBonus: 10),
      ]),
    ];
    return enemies.firstWhere((e) => e.id == id, orElse: () => enemies.first);
  }

  void _selectChoice(int index) {
    if (currentNode?.choices == null || index >= currentNode!.choices!.length) return;
    final choice = currentNode!.choices![index];

    if (choice.effects?.flag != null) {
      context.read<GameBloc>().add(FlagSet(choice.effects!.flag!));
    }
    if (choice.effects?.stat != null) {
      choice.effects!.stat!.forEach((stat, value) {
        final gs = context.read<GameBloc>().state.gameState;
        final currentVal = gs.playerStats[stat] ?? 5;
        gs.playerStats[stat] = currentVal + value;
      });
    }
    if (choice.effects?.groupRelation != null) {
      for (final id in ['laurencium', 'king', 'arsene']) {
        context.read<GameBloc>().add(RelationshipModified(id, choice.effects!.groupRelation!));
      }
    }
    if (choice.effects?.hemeryfbRelation != null) {
      context.read<GameBloc>().add(RelationshipModified('hemeryfb', choice.effects!.hemeryfbRelation!));
    }

    final nextNode = dialogueTree.firstWhere(
      (n) => n.id == choice.next,
      orElse: () => currentNode!,
    );
    setState(() {
      currentNode = nextNode;
      _textComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      builder: (context, state) {
        if (state.sceneData != null && state.sceneData!['dialogueId'] != null && currentNode == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            initDialogue(state.sceneData!['dialogueId']);
            setState(() {});
          });
        }

        if (currentNode == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: ColorPalettes.primary)),
          );
        }

        final speakerColor = ColorPalettes.characterColors[currentNode!.speaker] ?? Colors.white;

        return Scaffold(
          backgroundColor: Colors.black,
          body: KeyboardListener(
            focusNode: FocusNode()..requestFocus(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) {
                  _advance();
                }
              }
            },
            child: GestureDetector(
              onTap: _advance,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: ProceduralBackground(scene: 'dark_iai', time: _bgTime),
                    size: Size.infinite,
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (currentNode!.portrait != null)
                              _buildPortrait(currentNode!.portrait!),
                            Expanded(child: _buildDialogueBox(speakerColor)),
                          ],
                        ),
                      ),
                      if (currentNode!.hasChoices && _textComplete)
                        _buildChoicePanel(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortrait(String portraitId) {
    final pixels = CharacterPortraits.getPortrait(portraitId);
    return Container(
      width: 120,
      margin: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: _PortraitPainter(pixels),
        size: const Size(120, 180),
      ),
    );
  }

  Widget _buildDialogueBox(Color speakerColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A).withOpacity(0.9),
        border: Border.all(color: ColorPalettes.panelBorder.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentNode!.speaker.toUpperCase(),
            style: TextStyle(
              color: speakerColor,
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TypewriterText(
              text: currentNode!.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
              ),
              onComplete: () => setState(() => _textComplete = true),
            ),
          ),
          if (_textComplete && !currentNode!.hasChoices)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Appuyez pour continuer...',
                style: TextStyle(
                  color: ColorPalettes.primary.withOpacity(0.5),
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChoicePanel() {
    return GamePanel(
      width: double.infinity,
      height: (currentNode!.choices!.length * 55.0 + 20).clamp(0, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Choisir:', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 12)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: currentNode!.choices!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GameButton(
                    text: currentNode!.choices![index].text,
                    width: double.infinity,
                    height: 44,
                    onPressed: () => _selectChoice(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PortraitPainter extends CustomPainter {
  final List<List<Color>> pixels;

  _PortraitPainter(this.pixels);

  @override
  void paint(Canvas canvas, Size size) {
    if (pixels.isEmpty) return;
    final pixelW = size.width / pixels[0].length;
    final pixelH = size.height / pixels.length;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        if (pixels[y][x] == Colors.transparent) continue;
        paint.color = pixels[y][x];
        canvas.drawRect(
          Rect.fromLTWH(x * pixelW, y * pixelH, pixelW, pixelH),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PortraitPainter oldDelegate) => false;
}
