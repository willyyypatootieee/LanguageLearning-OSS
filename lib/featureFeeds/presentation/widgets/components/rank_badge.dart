import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class RankBadge extends StatelessWidget {
  final String rank;

  const RankBadge({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getRankColor(rank), _getRankColor(rank).withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRankIcon(rank), size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            _translateRank(rank),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank.toUpperCase()) {
      case 'BRONZE':
        return const Color(0xFFCD7F32);
      case 'SILVER':
        return const Color(0xFFC0C0C0);
      case 'GOLD':
        return const Color(0xFFFFD700);
      case 'PLATINUM':
        return const Color(0xFFE5E4E2);
      case 'DIAMOND':
        return const Color(0xFFB9F2FF);
      default:
        return AppColors.gray500;
    }
  }

  IconData _getRankIcon(String rank) {
    switch (rank.toUpperCase()) {
      case 'BRONZE':
        return Icons.military_tech;
      case 'SILVER':
        return Icons.workspace_premium;
      case 'GOLD':
        return Icons.emoji_events;
      case 'PLATINUM':
        return Icons.diamond;
      case 'DIAMOND':
        return Icons.auto_awesome;
      default:
        return Icons.star;
    }
  }

  String _translateRank(String rank) {
    switch (rank.toUpperCase()) {
      case 'BRONZE':
        return 'BRONZE';
      case 'SILVER':
        return 'SILVER';
      case 'GOLD':
        return 'GOLD';
      case 'PLATINUM':
        return 'PLATINUM';
      case 'DIAMOND':
        return 'DIAMOND';
      default:
        return 'UNRANKED';
    }
  }
}
