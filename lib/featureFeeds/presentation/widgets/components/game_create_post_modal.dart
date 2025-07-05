import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../data/constants/feeds_constants.dart';
import '../../cubit/feeds_cubit.dart';

/// Enhanced create post modal with gamified design
class GameCreatePostModal extends StatefulWidget {
  final FeedsCubit? feedsCubit;

  const GameCreatePostModal({super.key, this.feedsCubit});

  @override
  State<GameCreatePostModal> createState() => _GameCreatePostModalState();
}

class _GameCreatePostModalState extends State<GameCreatePostModal>
    with TickerProviderStateMixin {
  late final TextEditingController _contentController;
  late final TextEditingController _imageUrlController;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _imageUrlController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _imageUrlController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced header
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingL),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.1),
                                AppColors.accent.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.accent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Buat Postingan',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppTypography.headerFont,
                                        color: AppColors.gray900,
                                      ),
                                    ),
                                    Text(
                                      'Bagikan pencapaian belajar Anda',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.gray600,
                                        fontFamily: AppTypography.bodyFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingL),

                        // XP reward banner
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingM),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.success.withValues(alpha: 0.1),
                                AppColors.success.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '⚡',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dapatkan 50 XP',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                        fontFamily: AppTypography.bodyFont,
                                      ),
                                    ),
                                    Text(
                                      'Untuk setiap postingan yang Anda buat',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray600,
                                        fontFamily: AppTypography.bodyFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingL),

                        // Enhanced content input
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _contentController,
                            maxLines: 5,
                            maxLength: FeedsConstants.maxContentLength,
                            decoration: InputDecoration(
                              hintText:
                                  'Ceritakan pencapaian belajar Anda hari ini...',
                              hintStyle: TextStyle(
                                color: AppColors.gray400,
                                fontFamily: AppTypography.bodyFont,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(
                                AppConstants.spacingL,
                              ),
                              counterStyle: TextStyle(
                                color: AppColors.gray500,
                                fontSize: 12,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: AppTypography.bodyFont,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingM),

                        // Enhanced image URL input
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              hintText: 'URL gambar (opsional)',
                              hintStyle: TextStyle(
                                color: AppColors.gray400,
                                fontFamily: AppTypography.bodyFont,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(
                                AppConstants.spacingM,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.gray100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.gray500,
                                  size: 20,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: AppTypography.bodyFont,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.gray300,
                                    width: 1,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.spacingL,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: AppColors.gray600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: AppTypography.bodyFont,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingM),
                            Expanded(
                              flex: 2,
                              child:
                                  widget.feedsCubit == null
                                      ? _buildPostButton()
                                      : AnimatedBuilder(
                                        animation: widget.feedsCubit!,
                                        builder: (context, child) {
                                          return _buildPostButton(
                                            isLoading:
                                                widget
                                                    .feedsCubit!
                                                    .isCreatingPost,
                                          );
                                        },
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostButton({bool isLoading = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : _createPost,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                ],
                if (!isLoading) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                ],
                Text(
                  isLoading ? 'Memposting...' : 'Posting Sekarang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: AppTypography.bodyFont,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mohon tulis sesuatu untuk postingan Anda'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final imageUrl = _imageUrlController.text.trim();
    if (widget.feedsCubit != null) {
      final success = await widget.feedsCubit!.createPost(
        content,
        imageUrl: imageUrl.isEmpty ? null : imageUrl,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('🎉', style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Postingan berhasil dibuat! +50 XP didapat'),
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

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
