import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';

class SortPuzzle extends StatefulWidget {
  final String gameId;
  final VoidCallback onComplete;
  final VoidCallback onTimeout;

  const SortPuzzle({
    super.key,
    required this.gameId,
    required this.onComplete,
    required this.onTimeout,
  });

  @override
  State<SortPuzzle> createState() => _SortPuzzleState();
}

class _SortPuzzleState extends State<SortPuzzle> {
  late List<int> values;
  late List<int> sorted;
  int selectedIndex = -1;
  int score = 100;
  int timeLeft = 30;
  bool isComplete = false;
  bool isPlaying = false;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    values = List.generate(8, (i) => 10 + _random.nextInt(90));
    sorted = List.from(values)..sort();
    selectedIndex = -1;
    score = 100;
    timeLeft = widget.gameId == 'code_marathon' ? 60 : 30;
    isComplete = false;
    isPlaying = false;
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

  void _swap(int index) {
    if (!isPlaying || isComplete) return;

    if (selectedIndex == -1) {
      setState(() => selectedIndex = index);
    } else {
      if ((selectedIndex - index).abs() == 1) {
        setState(() {
          final temp = values[selectedIndex];
          values[selectedIndex] = values[index];
          values[index] = temp;
          selectedIndex = -1;
          score += 5;

          if (_isSorted()) {
            isComplete = true;
            score = max(0, score - timeLeft * 3);
            widget.onComplete();
          }
        });
      } else {
        setState(() => selectedIndex = index);
      }
    }
  }

  bool _isSorted() {
    for (int i = 0; i < values.length - 1; i++) {
      if (values[i] > values[i + 1]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!isPlaying) {
      return _buildIntro();
    }
    if (isComplete) {
      return _buildResult();
    }
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
            const Text(
              'Tri a Bulles',
              style: TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace', fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Classez les valeurs en ordre croissant\nen echangeant les elements adjacents.',
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
        const SizedBox(height: 20),
        _buildBars(),
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

  Widget _buildBars() {
    final maxValue = values.reduce(max).toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (index) {
        final value = values[index];
        final isSelected = selectedIndex == index;
        final isSorted = index < values.length - 1 && value <= values[index + 1] ||
            index == values.length - 1;

        return GestureDetector(
          onTap: () => _swap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 50,
            height: (value / maxValue) * 300,
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorPalettes.primary
                  : isSorted
                      ? ColorPalettes.hpGreen
                      : ColorPalettes.secondary,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white24,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }),
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
              timeLeft > 0 ? 'Termine!' : 'Temps ecoule!',
              style: TextStyle(
                color: timeLeft > 0 ? ColorPalettes.primary : Colors.red,
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
