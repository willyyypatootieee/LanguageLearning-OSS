import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class GameStatChip extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const GameStatChip({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bgColor, bgColor.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w700,
          fontFamily: AppTypography.bodyFont,
        ),
      ),
    );
  }
}
