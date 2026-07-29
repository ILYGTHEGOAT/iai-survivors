import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDuration;
  final VoidCallback? onComplete;
  final bool autoStart;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDuration = const Duration(milliseconds: 30),
    this.onComplete,
    this.autoStart = true,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  int _visibleChars = 0;
  Timer? _timer;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) _start();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _visibleChars = 0;
      _isComplete = false;
      _timer?.cancel();
      if (widget.autoStart) _start();
    }
  }

  void _start() {
    _timer = Timer.periodic(widget.charDuration, (timer) {
      if (_visibleChars < widget.text.length) {
        setState(() => _visibleChars++);
      } else {
        timer.cancel();
        _isComplete = true;
        widget.onComplete?.call();
      }
    });
  }

  void complete() {
    _timer?.cancel();
    setState(() {
      _visibleChars = widget.text.length;
      _isComplete = true;
    });
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _visibleChars > 0
        ? widget.text.substring(0, _visibleChars.clamp(0, widget.text.length))
        : '';

    return GestureDetector(
      onTap: _isComplete ? null : complete,
      child: Text(
        displayText + (_isComplete ? '' : '_'),
        style: widget.style,
      ),
    );
  }
}
