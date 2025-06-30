import 'package:flutter/material.dart';

class IPASymbolButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {}, // Placeholder for future interaction
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
              Text(
                symbol,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              Text(
                example,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
