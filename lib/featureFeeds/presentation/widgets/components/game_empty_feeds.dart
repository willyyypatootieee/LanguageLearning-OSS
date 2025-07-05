import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Enhanced empty state with gamified design
class GameEmptyFeedsWidget extends StatelessWidget {
  final VoidCallback? onCreatePost;

  const GameEmptyFeedsWidget({super.key, this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated floating icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * value),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.forum_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Fancy title with gradient
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ).createShader(bounds),
              child: Text(
                'Belum Ada Cerita!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppTypography.headerFont,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Encouraging subtitle
            Text(
              'Jadilah yang pertama membagikan\npencapaian belajar Anda!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.gray600,
                fontFamily: AppTypography.bodyFont,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Motivational stats
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gray50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'Dapatkan poin dengan membagikan:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray700,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTypography.bodyFont,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRewardItem('📝', 'Cerita\nBelajar', '+50 XP'),
                      _buildRewardItem('📸', 'Foto\nPencapaian', '+75 XP'),
                      _buildRewardItem('🎯', 'Tips &\nTrik', '+100 XP'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Fancy create post button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCreatePost,
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingXl,
                      vertical: AppConstants.spacingL,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        Text(
                          'Buat Postingan Pertama',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: AppTypography.bodyFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String emoji, String label, String reward) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.gray600,
            fontFamily: AppTypography.bodyFont,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            reward,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontFamily: AppTypography.bodyFont,
            ),
          ),
        ),
      ],
    );
  }
}
