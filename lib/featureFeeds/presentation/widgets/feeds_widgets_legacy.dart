import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../data/constants/feeds_constants.dart';
import '../../domain/models/post.dart';
import '../cubit/feeds_cubit.dart';

/// Widget for displaying a single post
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          FeedsConstants.postCardBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                CircleAvatar(
                  radius: FeedsConstants.avatarSize / 2,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    post.author.username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        post.author.currentRank,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray600,
                          fontFamily: AppTypography.bodyFont,
                        ),
                      ),
                    ],
                  ),
                ),
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
            const SizedBox(height: AppConstants.spacingM),
            // Post content
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray800,
                fontFamily: AppTypography.bodyFont,
                height: 1.5,
              ),
            ),
            // Post image (if available)
            if (post.imageUrl != null) ...[
              const SizedBox(height: AppConstants.spacingM),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.gray200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.gray500,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppConstants.spacingM),
            // Author stats and reactions
            Column(
              children: [
                // Author stats
                Row(
                  children: [
                    _buildStatChip(
                      '${post.author.totalXp} XP',
                      AppColors.primary,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    _buildStatChip(
                      '${post.author.streakDay} Day Streak',
                      AppColors.accent,
                    ),
                  ],
                ),
                // Reactions (if available)
                if (post.reactionsCount != null &&
                    post.reactionsCount!.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingS),
                  Row(
                    children:
                        post.reactionsCount!.entries
                            .where((entry) => entry.value > 0)
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(
                                  right: AppConstants.spacingS,
                                ),
                                child: _buildReactionChip(
                                  entry.key,
                                  entry.value,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: AppTypography.bodyFont,
        ),
      ),
    );
  }

  Widget _buildReactionChip(String emotion, int count) {
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 2),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
              fontFamily: AppTypography.bodyFont,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Widget shown when feeds is empty
class EmptyFeedsWidget extends StatelessWidget {
  final VoidCallback? onCreatePost;

  const EmptyFeedsWidget({super.key, this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feed_outlined, size: 80, color: AppColors.gray400),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              'No posts yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gray600,
                fontFamily: AppTypography.headerFont,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Be the first to share something with the community!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray500,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            ElevatedButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.add),
              label: const Text('Create Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                  vertical: AppConstants.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal for creating a new post
class CreatePostModal extends StatefulWidget {
  final FeedsCubit? feedsCubit;

  const CreatePostModal({super.key, this.feedsCubit});

  @override
  State<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  late final TextEditingController _contentController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusL),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTypography.headerFont,
                      color: AppColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingL),
              // Content input
              TextField(
                controller: _contentController,
                maxLines: 5,
                maxLength: FeedsConstants.maxContentLength,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(
                    color: AppColors.gray400,
                    fontFamily: AppTypography.bodyFont,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(AppConstants.spacingM),
                ),
                style: TextStyle(
                  fontFamily: AppTypography.bodyFont,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              // Image URL input (optional)
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  hintText: 'Image URL (optional)',
                  hintStyle: TextStyle(
                    color: AppColors.gray400,
                    fontFamily: AppTypography.bodyFont,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: const BorderSide(color: AppColors.gray300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(AppConstants.spacingM),
                  prefixIcon: const Icon(Icons.image, color: AppColors.gray400),
                ),
                style: TextStyle(
                  fontFamily: AppTypography.bodyFont,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontFamily: AppTypography.bodyFont,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child:
                        widget.feedsCubit == null
                            ? ElevatedButton(
                              onPressed: _createPost,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.spacingM,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusM,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppTypography.bodyFont,
                                ),
                              ),
                            )
                            : AnimatedBuilder(
                              animation: widget.feedsCubit!,
                              builder: (context, child) {
                                return ElevatedButton(
                                  onPressed:
                                      widget.feedsCubit!.isCreatingPost
                                          ? null
                                          : _createPost,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.spacingM,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.radiusM,
                                      ),
                                    ),
                                  ),
                                  child:
                                      widget.feedsCubit!.isCreatingPost
                                          ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Text(
                                            'Post',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily:
                                                  AppTypography.bodyFont,
                                            ),
                                          ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content for your post'),
          backgroundColor: AppColors.error,
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
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
