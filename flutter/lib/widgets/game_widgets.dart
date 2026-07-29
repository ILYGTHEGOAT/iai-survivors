import 'package:flutter/material.dart';
import '../../core/constants/color_palettes.dart';

class HpBar extends StatelessWidget {
  final double percent;
  final double width;
  final double height;
  final bool showLabel;

  const HpBar({
    super.key,
    required this.percent,
    this.width = 100,
    this.height = 10,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = percent > 0.6
        ? ColorPalettes.hpGreen
        : percent > 0.3
            ? ColorPalettes.hpYellow
            : ColorPalettes.hpRed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        if (showLabel)
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
      ],
    );
  }
}

class MpBar extends StatelessWidget {
  final double percent;
  final double width;
  final double height;

  const MpBar({
    super.key,
    required this.percent,
    this.width = 100,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percent.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalettes.mpBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class StatBar extends StatelessWidget {
  final String label;
  final double percent;
  final int value;
  final Color color;

  const StatBar({
    super.key,
    required this.label,
    required this.percent,
    required this.value,
    this.color = ColorPalettes.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$value',
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}

class GamePanel extends StatelessWidget {
  final double width;
  final double height;
  final Color? bgColor;
  final Color borderColor;
  final Widget child;

  const GamePanel({
    super.key,
    required this.width,
    required this.height,
    this.bgColor,
    this.borderColor = ColorPalettes.panelBorder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor ?? ColorPalettes.panelBg,
        border: Border.all(color: borderColor.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GameButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isDisabled;
  final double width;
  final double height;

  const GameButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSelected = false,
    this.isDisabled = false,
    this.width = 200,
    this.height = 40,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDisabled
        ? const Color(0xFF222233)
        : widget.isSelected
            ? ColorPalettes.primary.withOpacity(0.2)
            : _isHovered
                ? ColorPalettes.primary.withOpacity(0.1)
                : const Color(0xFF0D0D1A);

    final textColor = widget.isDisabled
        ? const Color(0xFF555566)
        : widget.isSelected
            ? ColorPalettes.primary
            : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: widget.isSelected ? ColorPalettes.primary : const Color(0xFF333344),
              width: widget.isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
