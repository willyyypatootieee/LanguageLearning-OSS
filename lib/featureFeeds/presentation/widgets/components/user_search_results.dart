import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../domain/models/user_search_result.dart';
import '../../cubit/feeds_cubit.dart';

/// Widget to display user search results with friend request functionality
class UserSearchResults extends StatelessWidget {
  final List<UserSearchResult> users;
  final FeedsCubit feedsCubit;
  final bool isLoading;

  const UserSearchResults({
    super.key,
    required this.users,
    required this.feedsCubit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.spacingM),
            Text(
              'Mencari pengguna...',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 14,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Text(
                  'Hasil Pencarian Pengguna',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray800,
                    fontFamily: AppTypography.bodyFont,
                  ),
                ),
              ],
            ),
          ),
          ...users.map((user) => _buildUserCard(context, user)),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserSearchResult user) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppConstants.spacingL,
        right: AppConstants.spacingL,
        bottom: AppConstants.spacingM,
      ),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Row(
        children: [
          // User avatar
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getRankColor(user.currentRank),
                      _getRankColor(user.currentRank).withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user.username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Level indicator
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    'Lv.${_calculateLevel(user.totalXp)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppConstants.spacingM),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRankColor(user.currentRank),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _translateRank(user.currentRank),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '⚡ ${user.totalXp} XP',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '🔥 ${user.streakDay} hari',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Friend request button
          _buildFriendButton(context, user),
        ],
      ),
    );
  }

  Widget _buildFriendButton(BuildContext context, UserSearchResult user) {
    if (user.isFriend) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 16, color: AppColors.success),
            const SizedBox(width: 4),
            Text(
              'Teman',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
          ],
        ),
      );
    }

    if (user.hasPendingRequest) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty, size: 16, color: AppColors.warning),
            const SizedBox(width: 4),
            Text(
              'Menunggu',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: feedsCubit,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _sendFriendRequest(context, user),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendFriendRequest(BuildContext context, UserSearchResult user) async {
    final success = await feedsCubit.sendFriendRequest(user.username);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('👤', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Permintaan pertemanan terkirim ke ${user.username}',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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

  String _translateRank(String rank) {
    switch (rank.toUpperCase()) {
      case 'BRONZE':
        return 'Perunggu';
      case 'SILVER':
        return 'Perak';
      case 'GOLD':
        return 'Emas';
      case 'PLATINUM':
        return 'Platinum';
      case 'DIAMOND':
        return 'Berlian';
      default:
        return 'Pemula';
    }
  }

  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }
}
