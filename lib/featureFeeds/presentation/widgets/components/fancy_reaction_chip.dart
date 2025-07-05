import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class FancyReactionChip extends StatelessWidget {
  final String emotion;
  final int count;

  const FancyReactionChip({
    super.key,
    required this.emotion,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    String emoji;
    switch (emotion) {
      case 'THUMBS_UP':
        emoji = '👍';
        break;
      case 'THUMBS_DOWN':
        emoji = '👎';
        break;
      case 'LOVE':
        emoji = '❤️';
        break;
      default:
        emoji = '👍';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontFamily: AppTypography.bodyFont,
            ),
          ),
        ],
      ),
    );
  }
}
