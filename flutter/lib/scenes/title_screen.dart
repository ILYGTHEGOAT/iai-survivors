import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../rendering/background/backgrounds.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _selectedIndex = 0;
  double _bgTime = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

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
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        setState(() => _selectedIndex = (_selectedIndex - 1).clamp(0, 2));
        break;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        setState(() => _selectedIndex = (_selectedIndex + 1).clamp(0, 2));
        break;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        _selectItem(_selectedIndex);
        break;
    }
  }

  void _selectItem(int index) {
    final bloc = context.read<GameBloc>();
    switch (index) {
      case 0:
        bloc.add(const GameStarted());
        break;
      case 1:
        bloc.add(const GameStarted(loadSave: true));
        break;
      case 2:
        bloc.add(const NotificationShown('Options a venir...', type: 'info'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _onKeyDown,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CustomPaint(
              painter: ProceduralBackground(scene: 'dark_iai', time: _bgTime),
              size: Size.infinite,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = _pulseAnimation.value;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'IA SURVIVORS',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: ColorPalettes.primary,
                            fontFamily: 'monospace',
                            shadows: [
                              Shadow(color: ColorPalettes.primary.withOpacity(0.5), blurRadius: 20),
                              Shadow(color: Colors.black, blurRadius: 4, offset: const Offset(2, 2)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SEMESTRE 1',
                          style: TextStyle(
                            fontSize: 28,
                            color: ColorPalettes.secondary,
                            fontFamily: 'monospace',
                            shadows: [
                              Shadow(color: ColorPalettes.secondary.withOpacity(0.5), blurRadius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Le code est la magie moderne, mais toute magie a un prix.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                      fontFamily: 'monospace',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 60),
                  GamePanel(
                    width: 360,
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItem(0, 'Nouvelle Partie'),
                        const SizedBox(height: 12),
                        _buildMenuItem(1, 'Continuer'),
                        const SizedBox(height: 12),
                        _buildMenuItem(2, 'Options'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Flèches/Haut-Bas + Entree ou Clic',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorPalettes.primary.withOpacity(0.4),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Text(
                'IA Survivors — Semestre 1 v1.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.3),
                  fontFamily: 'monospace',
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 28,
              child: Text(
                'Un jeu sur l\'amitie, le code, et la survie',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.3),
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, String text) {
    final isSelected = _selectedIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _selectedIndex = index),
      child: GameButton(
        text: text,
        isSelected: isSelected,
        width: 320,
        height: 44,
        onPressed: () => _selectItem(index),
      ),
    );
  }
}
