import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/color_palettes.dart';
import '../../widgets/game_widgets.dart';

enum PipeType { straight, corner, tee, cross }

class PipeCell {
  PipeType type;
  int rotation; // 0, 1, 2, 3 (multiples de 90 degres)

  PipeCell({required this.type, this.rotation = 0});

  void rotate() => rotation = (rotation + 1) % 4;

  bool get connectsTop =>
      type == PipeType.straight && (rotation == 0 || rotation == 2) ||
      type == PipeType.corner && (rotation == 0 || rotation == 3) ||
      type == PipeType.tee && (rotation == 0 || rotation == 1 || rotation == 3) ||
      type == PipeType.cross;

  bool get connectsBottom =>
      type == PipeType.straight && (rotation == 0 || rotation == 2) ||
      type == PipeType.corner && (rotation == 1 || rotation == 2) ||
      type == PipeType.tee && (rotation == 0 || rotation == 2 || rotation == 3) ||
      type == PipeType.cross;

  bool get connectsLeft =>
      type == PipeType.straight && (rotation == 1 || rotation == 3) ||
      type == PipeType.corner && (rotation == 0 || rotation == 1) ||
      type == PipeType.tee && (rotation == 1 || rotation == 2) ||
      type == PipeType.cross;

  bool get connectsRight =>
      type == PipeType.straight && (rotation == 1 || rotation == 3) ||
      type == PipeType.corner && (rotation == 2 || rotation == 3) ||
      type == PipeType.tee && (rotation == 1 || rotation == 3) ||
      type == PipeType.cross;
}

class PipePuzzle extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onTimeout;

  const PipePuzzle({
    super.key,
    required this.onComplete,
    required this.onTimeout,
  });

  @override
  State<PipePuzzle> createState() => _PipePuzzleState();
}

class _PipePuzzleState extends State<PipePuzzle> {
  late List<List<PipeCell>> grid;
  late List<List<int>> solution;
  int timeLeft = 40;
  bool isComplete = false;
  bool isPlaying = false;
  final _random = Random();
  static const int gridSize = 5;

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    grid = List.generate(gridSize, (y) {
      return List.generate(gridSize, (x) {
        final types = PipeType.values;
        return PipeCell(type: types[_random.nextInt(types.length)]);
      });
    });
    solution = List.generate(gridSize, (y) {
      return List.generate(gridSize, (x) => grid[y][x].rotation);
    });
    // Randomize rotations
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        grid[y][x].rotation = _random.nextInt(4);
      }
    }
    timeLeft = 40;
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

  void _rotatePipe(int y, int x) {
    if (!isPlaying || isComplete) return;
    setState(() {
      grid[y][x].rotate();
      if (_checkWin()) {
        isComplete = true;
        widget.onComplete();
      }
    });
  }

  bool _checkWin() {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        // Check connections to neighbors
        if (y > 0 && grid[y][x].connectsTop != grid[y - 1][x].connectsBottom) {
          // Allow asymmetric - just check top/bottom
        }
        if (x < gridSize - 1 && grid[y][x].connectsRight && !grid[y][x + 1].connectsLeft) return false;
        if (y < gridSize - 1 && grid[y][x].connectsBottom && !grid[y + 1][x].connectsTop) return false;
      }
    }
    // Check that all cells are connected
    return _isConnected();
  }

  bool _isConnected() {
    final visited = List.generate(gridSize, (_) => List.filled(gridSize, false));
    final queue = <Point>[const Point(0, 0)];
    visited[0][0] = true;
    int count = 1;

    while (queue.isNotEmpty) {
      final p = queue.removeLast();
      final y = p.y.toInt();
      final x = p.x.toInt();

      // Check all 4 directions
      if (grid[y][x].connectsTop && y > 0 && !visited[y - 1][x] && grid[y - 1][x].connectsBottom) {
        visited[y - 1][x] = true;
        queue.add(Point(x, y - 1));
        count++;
      }
      if (grid[y][x].connectsBottom && y < gridSize - 1 && !visited[y + 1][x] && grid[y + 1][x].connectsTop) {
        visited[y + 1][x] = true;
        queue.add(Point(x, y + 1));
        count++;
      }
      if (grid[y][x].connectsLeft && x > 0 && !visited[y][x - 1] && grid[y][x - 1].connectsRight) {
        visited[y][x - 1] = true;
        queue.add(Point(x - 1, y));
        count++;
      }
      if (grid[y][x].connectsRight && x < gridSize - 1 && !visited[y][x + 1] && grid[y][x + 1].connectsLeft) {
        visited[y][x + 1] = true;
        queue.add(Point(x + 1, y));
        count++;
      }
    }

    return count == gridSize * gridSize;
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
            const Text(
              'Data Flow',
              style: TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace', fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Connectez les tuyaux pour guider\nle flux de donnees.',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temps: $timeLeft', style: TextStyle(
              color: timeLeft <= 5 ? Colors.red : Colors.white,
              fontFamily: 'monospace', fontSize: 16,
            )),
          ],
        ),
        const SizedBox(height: 20),
        _buildGrid(),
      ],
    );
  }

  Widget _buildGrid() {
    final cellSize = 80.0;
    return SizedBox(
      width: cellSize * gridSize,
      height: cellSize * gridSize,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (context, index) {
          final y = index ~/ gridSize;
          final x = index % gridSize;
          return _buildPipeCell(y, x, cellSize);
        },
      ),
    );
  }

  Widget _buildPipeCell(int y, int x, double size) {
    final cell = grid[y][x];
    return GestureDetector(
      onTap: () => _rotatePipe(y, x),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          painter: _PipePainter(cell: cell),
          size: Size(size, size),
        ),
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
              'Reseau connecte!',
              style: TextStyle(
                color: ColorPalettes.primary,
                fontFamily: 'monospace',
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Temps restant: $timeLeft',
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  final PipeCell cell;

  _PipePainter({required this.cell});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorPalettes.primary
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final half = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(cell.rotation * pi / 2);
    canvas.translate(-center.dx, -center.dy);

    switch (cell.type) {
      case PipeType.straight:
        canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
        break;
      case PipeType.corner:
        canvas.drawLine(Offset(center.dx, center.dy), Offset(center.dx, 0), paint);
        canvas.drawLine(Offset(center.dx, center.dy), Offset(size.width, center.dy), paint);
        break;
      case PipeType.tee:
        canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
        canvas.drawLine(Offset(center.dx, center.dy), Offset(size.width, center.dy), paint);
        break;
      case PipeType.cross:
        canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
        canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PipePainter oldDelegate) => oldDelegate.cell.rotation != cell.rotation;
}
