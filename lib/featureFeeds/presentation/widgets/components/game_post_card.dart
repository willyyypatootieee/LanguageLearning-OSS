import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../domain/models/post.dart';
import 'rank_badge.dart';
import 'fancy_reaction_chip.dart';

/// Enhanced gamified post card with modern UI
class GamePostCard extends StatelessWidget {
  final Post post;

  const GamePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header with rank badge
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.gray50, Colors.white],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Enhanced avatar with rank glow
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          post.author.username[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    // Level badge
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          'Lv.${_calculateLevel(post.author.totalXp)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.author.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppTypography.headerFont,
                              color: AppColors.gray900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Rank badge with icon
                          RankBadge(rank: post.author.currentRank),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTimeAgo(post.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray500,
                          fontFamily: AppTypography.bodyFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL,
              vertical: AppConstants.spacingM,
            ),
            child: Text(
              post.content,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.gray800,
                fontFamily: AppTypography.bodyFont,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Post image with modern styling
          if (post.imageUrl != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.gray100, AppColors.gray200],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.gray400,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gambar tidak dapat dimuat',
                              style: TextStyle(
                                color: AppColors.gray500,
                                fontSize: 14,
                                fontFamily: AppTypography.bodyFont,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),
          ],

          // Stats and reactions section
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            decoration: BoxDecoration(
              color: AppColors.gray50.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Reactions row
                if (post.reactionsCount != null &&
                    post.reactionsCount!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Reaksi:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray600,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTypography.bodyFont,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        ...post.reactionsCount!.entries
                            .where((entry) => entry.value > 0)
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(
                                  right: AppConstants.spacingS,
                                ),
                                child: FancyReactionChip(
                                  emotion: entry.key,
                                  count: entry.value,
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
