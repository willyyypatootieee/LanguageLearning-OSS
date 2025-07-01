import 'package:flutter/material.dart';
import '../../core/services/tts_service.dart';

class IPASymbolButton extends StatefulWidget {
  final String symbol;
  final String label;
  final String example;

  const IPASymbolButton({
    super.key,
    required this.symbol,
    required this.label,
    required this.example,
  });

  @override
  State<IPASymbolButton> createState() => _IPASymbolButtonState();
}

class _IPASymbolButtonState extends State<IPASymbolButton> {
  bool _isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          if (_isSpeaking) return;

          setState(() {
            _isSpeaking = true;
          });

          try {
            // Use TTS to speak the English example word
            final ttsService = TTSService();
            await ttsService.speak(widget.example);
          } finally {
            if (mounted) {
              setState(() {
                _isSpeaking = false;
              });
            }
          }
        },
        child: Container(
          width: 80,
          // Removed fixed height to allow content to determine height
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Prevent overflow by using min size
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isSpeaking
                  ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                  : Text(
                    widget.symbol,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              Text(
                widget.example,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
