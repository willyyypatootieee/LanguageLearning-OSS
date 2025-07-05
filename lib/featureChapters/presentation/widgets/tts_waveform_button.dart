import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class TTSWaveformButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;

  const TTSWaveformButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<TTSWaveformButton> createState() => _TTSWaveformButtonState();
}

class _TTSWaveformButtonState extends State<TTSWaveformButton>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 1.0,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playTTS() async {
    setState(() => _isPlaying = true);
    _controller.repeat(reverse: true);
    await _flutterTts.speak(widget.text);
    setState(() => _isPlaying = false);
    _controller.stop();
    _controller.value = 1.0;
  }

  Widget _buildFakeWaveform() {
    return SizedBox(
      height: 24,
      width: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + i * 60),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height:
                _isPlaying
                    ? 10.0 + (i.isEven ? 10 : 0) + (i == 2 ? 8 : 0)
                    : 10.0,
            decoration: BoxDecoration(
              color:
                  Colors
                      .orangeAccent, // Changed from blueAccent to orangeAccent
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _playTTS();
        widget.onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.borderColor ?? Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: _isPlaying ? _controller : AlwaysStoppedAnimation(1.0),
              child: Icon(
                Icons.volume_up,
                color: widget.isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildFakeWaveform()),
          ],
        ),
      ),
    );
  }
}
