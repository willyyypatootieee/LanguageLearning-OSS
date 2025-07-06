import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../domain/models/post.dart';
import '../../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import 'package:provider/provider.dart';
import '../../cubit/feeds_cubit.dart';
import 'rank_badge.dart';
import 'fancy_reaction_chip.dart';

/// Enhanced gamified post card with modern UI
class GamePostCard extends StatefulWidget {
  final Post post;
  final bool isReply;
  final VoidCallback? onPostDeleted;
  final VoidCallback? onReplyAdded;

  const GamePostCard({
    super.key,
    required this.post,
    this.isReply = false,
    this.onPostDeleted,
    this.onReplyAdded,
  });

  @override
  State<GamePostCard> createState() => _GamePostCardState();
}

class _GamePostCardState extends State<GamePostCard> with AutomaticKeepAliveClientMixin {
  bool _isReplyFormVisible = false;
  late final TextEditingController _replyController;
  String? _currentUserId;
  bool _isLoading = false;
  
  // Cached values to prevent rebuilds
  late final bool _isPostOwner;
  late final String _timeAgo;
  late final int _level;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
    _loadCurrentUser();
    _timeAgo = _getTimeAgo(widget.post.createdAt);
    _level = _calculateLevel(widget.post.author.totalXp);
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final authDataSource = AuthLocalDataSource();
    final user = await authDataSource.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _currentUserId = user.id;
        _isPostOwner = user.id == widget.post.authorId;
      });
    }
  }

  // Use getter only if _currentUserId isn't loaded yet
  bool get _isPostOwnerFallback =>
      _currentUserId != null && widget.post.authorId == _currentUserId;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Container(
      margin: EdgeInsets.only(
        bottom: AppConstants.spacingL,
        left: widget.isReply ? AppConstants.spacingXl : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
        border:
            widget.isReply
                ? Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                )
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header with rank badge and delete button
          _buildHeader(),
          
          // Post content
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Text(
              widget.post.content,
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
          if (widget.post.imageUrl != null) 
            _buildPostImage(),
          
          // Stats and reactions section
          _buildReactionsSection(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gray50, Colors.white],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Enhanced avatar with rank glow
          _buildAvatar(),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.post.author.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: AppTypography.headerFont,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Rank badge with icon
                    RankBadge(rank: widget.post.author.currentRank),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                    fontFamily: AppTypography.bodyFont,
                  ),
                ),
              ],
            ),
          ),
          // Delete button (only visible to post owner)
          if (_currentUserId != null ? _isPostOwner : _isPostOwnerFallback)
            IconButton(
              onPressed: _deletePost,
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 20,
              ),
              tooltip: 'Hapus post',
            ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            child: Text(
              widget.post.author.username[0].toUpperCase(),
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
              'Lv.$_level',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPostImage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Image.network(
                widget.post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 600, // Add cache width to improve performance
                cacheHeight: 600, // Add cache height to improve performance
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
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
    );
  }
  
  Widget _buildReactionsSection() {
    // Use const for static widgets when possible
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(249, 250, 251, 0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Reactions row
          _buildReactionsList(),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Action buttons
          _buildActionButtons(),
          
          // Reply form
          if (_isReplyFormVisible) 
            _buildReplyForm(),
          
          // Reply counter
          if (widget.post.replies != null && widget.post.replies!.isNotEmpty) 
            _buildRepliesInfo(),
        ],
      ),
    );
  }

  Widget _buildReactionsList() {
    // Optimized reactions list builder
    if (widget.post.reactionsCount != null &&
        widget.post.reactionsCount!.isNotEmpty) {
      return Container(
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
            ...widget.post.reactionsCount!.entries
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
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reply button
        _ActionButton(
          icon: Icons.reply,
          label: 'Balas',
          onTap: () {
            setState(() {
              _isReplyFormVisible = !_isReplyFormVisible;
            });
          },
        ),

        // Like button
        _ReactionButton(
          emotion: 'THUMBS_UP',
          label: 'Suka',
          count: widget.post.reactionsCount?['THUMBS_UP'] ?? 0,
          postId: widget.post.id,
        ),

        // Love button
        _ReactionButton(
          emotion: 'LOVE',
          label: 'Cinta',
          count: widget.post.reactionsCount?['LOVE'] ?? 0,
          postId: widget.post.id,
        ),

        // Expand replies button (only if post has replies)
        // Temporarily disabled until individual post API is fixed
        /*
        if (widget.post.replies != null &&
            widget.post.replies!.isNotEmpty)
          _ActionButton(
            icon:
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
            label:
                _isExpanded
                    ? 'Tutup'
                    : '${widget.post.replies!.length} Balasan',
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        */
      ],
    );
  }

  Widget _buildReplyForm() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _replyController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ketik balasanmu di sini...',
              hintStyle: TextStyle(
                color: AppColors.gray400,
                fontFamily: AppTypography.bodyFont,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.gray300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(AppConstants.spacingM),
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isReplyFormVisible = false;
                    _replyController.clear();
                  });
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.gray600),
                child: const Text('Batal'),
              ),
              const SizedBox(width: AppConstants.spacingS),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitReply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingL,
                    vertical: AppConstants.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text('Kirim'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final feedsCubit = Provider.of<FeedsCubit>(context, listen: false);
      final replyContent = _replyController.text.trim();

      final result = await feedsCubit.createPost(
        replyContent,
        parentId: widget.post.id,
      );

      if (result) {
        // Clear form and hide it
        _replyController.clear();
        setState(() {
          _isReplyFormVisible = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Balasan berhasil dikirim'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );

        // Refresh the feed to get the updated replies
        await _refreshPost();

        // Notify parent
        if (widget.onReplyAdded != null) {
          widget.onReplyAdded!();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal mengirim balasan'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error posting reply: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim balasan: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePost() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Post'),
            content: const Text('Apakah Anda yakin ingin menghapus post ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final feedsCubit = Provider.of<FeedsCubit>(context, listen: false);
      final success = await feedsCubit.deletePost(widget.post.id);

      if (success) {
        if (widget.onPostDeleted != null) {
          widget.onPostDeleted!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Post berhasil dihapus'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menghapus post'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      print('Error deleting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshPost() async {
    try {
      final feedsCubit = Provider.of<FeedsCubit>(context, listen: false);
      // Instead of getting individual post, refresh the entire feed
      await feedsCubit.loadPosts(forceRefresh: true);
    } catch (e) {
      print('Error refreshing posts: $e');
    }
  }

  // The remaining methods implement specific UI components
  // Each method is responsible for building a specific part of the UI
  
  // Helper methods
  int _calculateLevel(int xp) {
    // Simple level calculation based on XP
    return (xp / 100).floor() + 1;
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit';
    } else {
      return 'Baru saja';
    }
  }
  
  // This method is implemented earlier in the file
  
  Widget _buildRepliesInfo() {
    final repliesCount = widget.post.replies?.length ?? 0;
    
    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.spacingS),
      child: InkWell(
        onTap: () {
          // Navigate to detailed view of post with replies
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingS,
            horizontal: AppConstants.spacingM,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.comment_outlined,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '$repliesCount ${repliesCount == 1 ? 'balasan' : 'balasan'}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Removed duplicated method
  
  // Removed duplicated method
  
  // Removed duplicated method
}

/// Action button for post interactions
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.gray600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray700,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reaction button that handles adding/removing reactions
class _ReactionButton extends StatefulWidget {
  final String emotion;
  final String label;
  final int count;
  final String postId;

  const _ReactionButton({
    required this.emotion,
    required this.label,
    required this.count,
    required this.postId,
  });

  @override
  _ReactionButtonState createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton> {
  bool _isActive = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isLoading ? null : _toggleReaction,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              _getEmotionIcon(),
            const SizedBox(width: 4),
            Text(
              widget.count > 0
                  ? '${widget.label} (${widget.count})'
                  : widget.label,
              style: TextStyle(
                fontSize: 12,
                color: _isActive ? AppColors.primary : AppColors.gray700,
                fontWeight: _isActive ? FontWeight.bold : FontWeight.normal,
                fontFamily: AppTypography.bodyFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getEmotionIcon() {
    String emoji;
    switch (widget.emotion) {
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

    return Text(emoji, style: const TextStyle(fontSize: 16));
  }

  Future<void> _toggleReaction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feedsCubit = Provider.of<FeedsCubit>(context, listen: false);

      if (_isActive) {
        // Remove reaction
        final success = await feedsCubit.removeReaction(widget.postId);
        if (success) {
          setState(() {
            _isActive = false;
          });
        } else {
          throw Exception('Failed to remove reaction');
        }
      } else {
        // Add reaction
        final reaction = await feedsCubit.addReaction(
          widget.postId,
          widget.emotion,
        );
        if (reaction != null) {
          setState(() {
            _isActive = true;
          });
        } else {
          throw Exception('Failed to add reaction');
        }
      }
    } catch (e) {
      print('Error toggling reaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fitur reaksi sedang dalam perbaikan'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
