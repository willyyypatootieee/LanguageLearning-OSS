import 'dart:math' as Math;
import 'package:flutter/material.dart';

/// Enhanced microphone waveform visualization with more prominent display.
class MicWaveformPlaceholder extends StatefulWidget {
  final bool isActive;
  final double? soundLevel; // Optional real sound level data

  const MicWaveformPlaceholder({
    super.key,
    this.isActive = true,
    this.soundLevel,
  });

  @override
  State<MicWaveformPlaceholder> createState() => _MicWaveformPlaceholderState();
}

class _MicWaveformPlaceholderState extends State<MicWaveformPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _lastSoundLevel = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ), // Faster animation for more responsiveness
    )..repeat();
  }

  @override
  void didUpdateWidget(MicWaveformPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update sound level if provided
    if (widget.soundLevel != null) {
      _lastSoundLevel = widget.soundLevel!;
    }

    // Ensure animation is running when active
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background circle for microphone
            if (widget.isActive)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.withOpacity(0.2),
                ),
              ),

            // Main waveform
            CustomPaint(
              size: const Size(200, 60), // Larger size for more prominence
              painter: _EnhancedWaveformPainter(
                animValue: _controller.value,
                isActive: widget.isActive,
                soundLevel: widget.soundLevel ?? _lastSoundLevel,
              ),
            ),

            // Microphone icon in the center
            Icon(
              Icons.mic,
              color: widget.isActive ? Colors.orangeAccent : Colors.white54,
              size: 24,
            ),
          ],
        );
      },
    );
  }
}

class _EnhancedWaveformPainter extends CustomPainter {
  final double animValue;
  final bool isActive;
  final double soundLevel;

  _EnhancedWaveformPainter({
    required this.animValue,
    required this.isActive,
    this.soundLevel = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Use vibrant orange for active state
    final color =
        isActive ? Colors.orangeAccent : Colors.white.withOpacity(0.3);

    final paint =
        Paint()
          ..color = color
          ..strokeWidth =
              8 // Thicker bars
          ..strokeCap = StrokeCap.round;

    final midY = size.height / 2;
    final bars = 11; // More bars for better visualization

    // Dynamic intensity based on active state
    final intensity = isActive ? (0.4 + soundLevel.clamp(0, 30) / 40) : 0.1;

    for (int i = 0; i < bars; i++) {
      final x = i * (size.width / (bars - 1));
      double barHeight;

      if (isActive) {
        // More dynamic wave pattern for active state
        final phase = animValue * 2 * Math.pi;
        final barIndex = i - (bars ~/ 2);

        // Create wave pattern that's more prominent in the center
        barHeight =
            size.height /
            2 *
            intensity *
            (0.4 + 0.6 * (0.5 + 0.5 * Math.sin(phase + barIndex * 0.6))) *
            (1 - 0.2 * (barIndex.abs() / (bars ~/ 2)));
      } else {
        // Subtle movement even when inactive
        barHeight = size.height * 0.08;
      }

      canvas.drawLine(
        Offset(x, midY - barHeight),
        Offset(x, midY + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedWaveformPainter oldDelegate) =>
      oldDelegate.animValue != animValue ||
      oldDelegate.isActive != isActive ||
      oldDelegate.soundLevel != soundLevel;
}
