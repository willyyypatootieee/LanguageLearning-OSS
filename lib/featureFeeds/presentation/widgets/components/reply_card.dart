import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../domain/models/post.dart';
import 'package:provider/provider.dart';
import '../../cubit/feeds_cubit.dart';
import '../../../../featureAuthentication/data/datasources/auth_local_datasource.dart';

/// Card widget for displaying replies with minimal styling
class ReplyCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onReplyDeleted;

  const ReplyCard({super.key, required this.post, this.onReplyDeleted});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  String? _currentUserId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authDataSource = AuthLocalDataSource();
    final user = await authDataSource.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        _currentUserId = user.id;
      });
    }
  }

  bool get _isReplyOwner =>
      _currentUserId != null && widget.post.authorId == _currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row with delete option
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  widget.post.author.username[0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(width: AppConstants.spacingS),

              // Author name and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author.username,
                      style: TextStyle(
                        color: AppColors.gray800,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                    Text(
                      _getTimeAgo(widget.post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
                        fontFamily: AppTypography.bodyFont,
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button (only for reply owner)
              if (_isReplyOwner)
                IconButton(
                  onPressed: _isLoading ? null : _deleteReply,
                  icon:
                      _isLoading
                          ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red.shade700,
                            ),
                          )
                          : Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade700,
                            size: 18,
                          ),
                  tooltip: 'Hapus balasan',
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingS),

          // Reply content
          Text(
            widget.post.content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray800,
              fontFamily: AppTypography.bodyFont,
              height: 1.5,
            ),
          ),

          // Image if any
          if (widget.post.imageUrl != null) ...[
            const SizedBox(height: AppConstants.spacingM),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.post.imageUrl!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.gray400,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Reactions summary (minimal)
          if (widget.post.reactionsCount != null &&
              widget.post.reactionsCount!.isNotEmpty &&
              widget.post.reactionsCount!.values.any((count) => count > 0)) ...[
            const SizedBox(height: AppConstants.spacingS),
            Row(
              children: [
                for (var entry in widget.post.reactionsCount!.entries)
                  if (entry.value > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        visualDensity: VisualDensity.compact,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getEmotionIcon(entry.key),
                            const SizedBox(width: 4),
                            Text(
                              entry.value.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _getEmotionIcon(String emotion) {
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

    return Text(emoji, style: const TextStyle(fontSize: 14));
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

  Future<void> _deleteReply() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Balasan'),
            content: const Text(
              'Apakah Anda yakin ingin menghapus balasan ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                ),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final feedsCubit = Provider.of<FeedsCubit>(context, listen: false);
      final success = await feedsCubit.deletePost(widget.post.id);

      if (success) {
        if (widget.onReplyDeleted != null) {
          widget.onReplyDeleted!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Balasan berhasil dihapus'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal menghapus balasan'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      print('Error deleting reply: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
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
}
