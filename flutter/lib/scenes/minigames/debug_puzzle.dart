import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/color_palettes.dart';
import '../../widgets/game_widgets.dart';

class DebugPuzzle extends StatefulWidget {
  final String gameId;
  final VoidCallback onComplete;
  final VoidCallback onTimeout;

  const DebugPuzzle({
    super.key,
    required this.gameId,
    required this.onComplete,
    required this.onTimeout,
  });

  @override
  State<DebugPuzzle> createState() => _DebugPuzzleState();
}

class _DebugPuzzleState extends State<DebugPuzzle> {
  late List<String> lines;
  late int buggyLine;
  int score = 0;
  int timeLeft = 20;
  bool isComplete = false;
  bool isPlaying = false;
  int selectedLine = -1;
  final _random = Random();

  final _codeTemplates = [
    [
      'function calculerSomme(tableau) {',
      '  let total = 0;',
      '  for (let i = 0; i <= tableau.length; i++) {',
      '    total += tableau[i];',
      '  }',
      '  return total;',
      '}',
    ],
    [
      'function trouverMax(liste) {',
      '  let max = liste[0];',
      '  for (let i = 1; i < liste.length; i++) {',
      '    if (liste[i] > max) {',
      '      max = liste[i++];',
      '    }',
      '  }',
      '  return max;',
      '}',
    ],
    [
      'function trier(tableau) {',
      '  for (let i = 0; i < tableau.length; i++) {',
      '    for (let j = i; j < tableau.length; j++) {',
      '      if (tableau[i] > tableau[j]) {',
      '        let temp = tableau[i];',
      '        tableau[i] = tableau[i];',
      '        tableau[j] = temp;',
      '      }',
      '    }',
      '  }',
      '  return tableau;',
      '}',
    ],
  ];

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    final template = _codeTemplates[_random.nextInt(_codeTemplates.length)];
    lines = List.from(template);
    buggyLine = 1 + _random.nextInt(lines.length - 2);
    score = 0;
    timeLeft = 20;
    isComplete = false;
    isPlaying = false;
    selectedLine = -1;
  }

  void _startGame() {
    setState(() => isPlaying = true);
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || isComplete) return false;
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          isComplete = true;
          widget.onTimeout();
        }
      });
      return timeLeft > 0 && !isComplete;
    });
  }

  void _selectLine(int index) {
    if (!isPlaying || isComplete || index == 0 || index == lines.length - 1) return;

    setState(() {
      selectedLine = index;
      if (index == buggyLine) {
        score = 100;
        isComplete = true;
        widget.onComplete();
      } else {
        score = max(0, score - 10);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isPlaying) return _buildIntro();
    if (isComplete) return _buildResult();
    return _buildGame();
  }

  Widget _buildIntro() {
    return Center(
      child: GamePanel(
        width: 400,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.gameId == 'audio_analysis' ? 'Analyse Audio' : 'Debug Marathon',
              style: const TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace', fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Trouvez le bug dans le code!\nCliquez sur la ligne erronee.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 14),
            ),
            const SizedBox(height: 24),
            GameButton(text: 'Commencer', width: 200, onPressed: _startGame),
          ],
        ),
      ),
    );
  }

  Widget _buildGame() {
    return Column(
      children: [
        _buildHUD(),
        const SizedBox(height: 16),
        _buildCodeEditor(),
      ],
    );
  }

  Widget _buildHUD() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Score: $score', style: TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace', fontSize: 16)),
        const SizedBox(width: 40),
        Text(
          'Temps: $timeLeft',
          style: TextStyle(
            color: timeLeft <= 5 ? Colors.red : Colors.white,
            fontFamily: 'monospace',
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeEditor() {
    return GamePanel(
      width: 700,
      height: 350,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final isSelected = selectedLine == index;
          final isClickable = index > 0 && index < lines.length - 1;

          return GestureDetector(
            onTap: isClickable ? () => _selectLine(index) : null,
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.red.withOpacity(0.2)
                    : isClickable
                        ? Colors.white.withOpacity(0.05)
                        : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.white12,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isClickable ? Colors.white54 : Colors.white24,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      lines[index],
                      style: TextStyle(
                        color: isClickable ? Colors.white : Colors.white38,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: GamePanel(
        width: 400,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              score > 0 ? 'Bug trouve!' : 'Temps ecoule!',
              style: TextStyle(
                color: score > 0 ? ColorPalettes.primary : Colors.red,
                fontFamily: 'monospace',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $score',
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
