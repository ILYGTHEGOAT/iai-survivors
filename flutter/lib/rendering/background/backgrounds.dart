import 'dart:math';
import 'package:flutter/material.dart';

class PixelArtPainter extends CustomPainter {
  final List<List<Color>> pixelGrid;
  final int pixelSize;

  PixelArtPainter({
    required this.pixelGrid,
    this.pixelSize = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int y = 0; y < pixelGrid.length; y++) {
      for (int x = 0; x < pixelGrid[y].length; x++) {
        paint.color = pixelGrid[y][x];
        canvas.drawRect(
          Rect.fromLTWH(
            x * pixelSize.toDouble(),
            y * pixelSize.toDouble(),
            pixelSize.toDouble(),
            pixelSize.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelArtPainter oldDelegate) => false;
}

class ProceduralBackground extends CustomPainter {
  final String scene;
  final double time;

  ProceduralBackground({required this.scene, this.time = 0});

  @override
  void paint(Canvas canvas, Size size) {
    switch (scene) {
      case 'dark_iai':
        _drawDarkIai(canvas, size);
        break;
      case 'campus_day':
        _drawCampusDay(canvas, size);
        break;
      case 'campus_night':
        _drawCampusNight(canvas, size);
        break;
      case 'classroom':
        _drawClassroom(canvas, size);
        break;
      case 'combat':
        _drawCombat(canvas, size);
        break;
      case 'labyrinth':
        _drawLabyrinth(canvas, size);
        break;
      case 'server_room':
        _drawServerRoom(canvas, size);
        break;
      default:
        _drawDarkIai(canvas, size);
    }
  }

  void _drawDarkIai(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF050510);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final random = Random(42);
    final greenPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final speed = 30 + random.nextDouble() * 60;
      final y = ((time * speed + i * 50) % (size.height + 100)) - 50;
      final alpha = 0.1 + random.nextDouble() * 0.3;
      greenPaint.color = Color.fromRGBO(0, 255, 128, alpha);
      canvas.drawRect(Rect.fromLTWH(x, y, 2, 8 + random.nextDouble() * 20), greenPaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromRGBO(0, 200, 100, 0.15),
          const Color.fromRGBO(0, 200, 100, 0),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 400,
        height: 400,
      ));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);
  }

  void _drawCampusDay(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4488CC), Color(0xFF88BBEE)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.6), skyPaint);

    final groundPaint = Paint()..color = const Color(0xFF44AA44);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4), groundPaint);

    final buildingPaint = Paint()..color = const Color(0xFF888899);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.3, size.height * 0.25, size.width * 0.4, size.height * 0.45), buildingPaint);

    final windowPaint = Paint()..color = const Color(0xFFAADDFF);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 5; col++) {
        final wx = size.width * 0.33 + col * size.width * 0.07;
        final wy = size.height * 0.3 + row * size.height * 0.08;
        canvas.drawRect(Rect.fromLTWH(wx, wy, size.width * 0.04, size.height * 0.04), windowPaint);
      }
    }
  }

  void _drawCampusNight(Canvas canvas, Size size) {
    final skyPaint = Paint()..color = const Color(0xFF0A0A2E);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.6), skyPaint);

    final random = Random(123);
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 60; i++) {
      starPaint.color = Color.fromRGBO(255, 255, 200, 0.3 + random.nextDouble() * 0.7);
      canvas.drawCircle(
        Offset(random.nextDouble() * size.width, random.nextDouble() * size.height * 0.5),
        1 + random.nextDouble(),
        starPaint,
      );
    }

    final groundPaint = Paint()..color = const Color(0xFF1A3322);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4), groundPaint);

    final buildingPaint = Paint()..color = const Color(0xFF333344);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.3, size.height * 0.25, size.width * 0.4, size.height * 0.45), buildingPaint);

    final windowPaint = Paint()..color = const Color(0xFFCCAA44);
    final windowOffPaint = Paint()..color = const Color(0xFF222233);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 5; col++) {
        final wx = size.width * 0.33 + col * size.width * 0.07;
        final wy = size.height * 0.3 + row * size.height * 0.08;
        final isLit = random.nextBool();
        canvas.drawRect(Rect.fromLTWH(wx, wy, size.width * 0.04, size.height * 0.04),
            isLit ? windowPaint : windowOffPaint);
      }
    }
  }

  void _drawClassroom(Canvas canvas, Size size) {
    final wallPaint = Paint()..color = const Color(0xFFCCBB99);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), wallPaint);

    final boardPaint = Paint()..color = const Color(0xFF225533);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.15, size.height * 0.1, size.width * 0.7, size.height * 0.35), boardPaint);

    final floorPaint = Paint()..color = const Color(0xFF887766);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3), floorPaint);

    final deskPaint = Paint()..color = const Color(0xFF996633);
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final dx = size.width * 0.15 + col * size.width * 0.2;
        final dy = size.height * 0.55 + row * size.height * 0.08;
        canvas.drawRect(Rect.fromLTWH(dx, dy, size.width * 0.12, size.height * 0.04), deskPaint);
      }
    }
  }

  void _drawCombat(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0A0A18);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final gridPaint = Paint()
      ..color = const Color(0xFF1A1A33)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), gridPaint);
    }
    for (int i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), gridPaint);
    }

    final floorPaint = Paint()..color = const Color(0xFF113322);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.75, size.width, size.height * 0.25), floorPaint);
  }

  void _drawLabyrinth(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0A0020);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final random = Random(77);
    final blockPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final alpha = 0.1 + random.nextDouble() * 0.3;
      blockPaint.color = Color.fromRGBO(128, 50, 200, alpha);
      canvas.drawRect(
        Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          20 + random.nextDouble() * 60,
          20 + random.nextDouble() * 60,
        ),
        blockPaint,
      );
    }
  }

  void _drawServerRoom(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0A0A14);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final rackPaint = Paint()..color = const Color(0xFF222233);
    for (int i = 0; i < 6; i++) {
      final rx = size.width * 0.08 + i * size.width * 0.15;
      canvas.drawRect(Rect.fromLTWH(rx, size.height * 0.1, size.width * 0.1, size.height * 0.6), rackPaint);
    }

    final random = Random(99);
    final ledPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final rx = size.width * 0.08 + i * size.width * 0.15;
      for (int j = 0; j < 8; j++) {
        final isGreen = random.nextBool();
        ledPaint.color = isGreen ? const Color(0xFF00CC44) : const Color(0xFFCC2222);
        canvas.drawCircle(
          Offset(rx + size.width * 0.05, size.height * 0.15 + j * size.height * 0.06),
          3,
          ledPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ProceduralBackground oldDelegate) =>
      oldDelegate.time != time || oldDelegate.scene != scene;
}
