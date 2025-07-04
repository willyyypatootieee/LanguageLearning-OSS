import 'dart:math' as Math;
import 'package:flutter/material.dart';

/// Placeholder for a mic waveform visualization.
/// Replace with real mic input visualization using a package like `audio_waveforms` or `flutter_sound`.
class MicWaveformPlaceholder extends StatefulWidget {
  final bool isActive;
  const MicWaveformPlaceholder({super.key, this.isActive = true});

  @override
  State<MicWaveformPlaceholder> createState() => _MicWaveformPlaceholderState();
}

class _MicWaveformPlaceholderState extends State<MicWaveformPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.value;
    return CustomPaint(
      size: const Size(80, 40),
      painter: _SmoothWaveformPainter(value, widget.isActive),
    );
  }
}

class _SmoothWaveformPainter extends CustomPainter {
  final double animValue;
  final bool isActive;
  _SmoothWaveformPainter(this.animValue, this.isActive);

  @override
  void paint(Canvas canvas, Size size) {
    final color = Colors.orangeAccent;
    final paint =
        Paint()
          ..color = color
          ..strokeWidth =
              7 // thicker bars
          ..strokeCap = StrokeCap.round;
    final midY = size.height / 2;
    final bars = 8;
    for (int i = 0; i < bars; i++) {
      final x = i * (size.width / (bars - 1));
      double barHeight;
      if (isActive) {
        final phase = animValue * 2 * 3.14159;
        barHeight =
            (size.height / 2) *
            (0.35 + 0.55 * (0.5 + 0.5 * (Math.sin(phase + i * 0.7))));
      } else {
        barHeight = 4; // Flat but still visible when muted
      }
      canvas.drawLine(
        Offset(x, midY - barHeight),
        Offset(x, midY + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SmoothWaveformPainter oldDelegate) =>
      oldDelegate.animValue != animValue || oldDelegate.isActive != isActive;
}
