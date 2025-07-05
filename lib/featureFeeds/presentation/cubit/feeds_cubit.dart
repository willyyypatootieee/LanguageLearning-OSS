import 'package:flutter/foundation.dart';
import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';

/// Cubit for managing feeds state
class FeedsCubit extends ChangeNotifier {
  final GetPostsUsecase _getPostsUsecase;
  final CreatePostUsecase _createPostUsecase;

  bool _isDisposed = false;
  bool _hasInitiallyLoaded = false;

  FeedsCubit(this._getPostsUsecase, this._createPostUsecase);

  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isCreatingPost = false;
  String? _errorMessage;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isCreatingPost => _isCreatingPost;
  String? get errorMessage => _errorMessage;
  bool get hasInitiallyLoaded => _hasInitiallyLoaded;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _setCreatingPost(bool creating) {
    _isCreatingPost = creating;
    _safeNotifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    _safeNotifyListeners();
  }

  /// Load posts feed
  Future<void> loadPosts({bool forceRefresh = false}) async {
    // If we have cached data and not forcing refresh, don't show loading
    if (_hasInitiallyLoaded && !forceRefresh) {
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final posts = await _getPostsUsecase();
      _posts = posts;
      _hasInitiallyLoaded = true;
      _setLoading(false);
    } catch (e) {
      print('Error loading posts in cubit: $e');
      // Don't show error to user for server errors, just log them
      _setLoading(false);
      _hasInitiallyLoaded =
          true; // Still mark as loaded to prevent infinite loading
    }
  }

  /// Create a new post
  Future<bool> createPost(
    String content, {
    String? imageUrl,
    String? parentId,
  }) async {
    if (content.trim().isEmpty) {
      _setError('Post content cannot be empty');
      return false;
    }

    _setCreatingPost(true);
    _setError(null);

    try {
      final request = CreatePostRequest(
        content: content.trim(),
        imageUrl: imageUrl,
        parentId: parentId,
      );

      await _createPostUsecase(request);

      _setCreatingPost(false);

      // Always refresh posts after attempting to create
      await loadPosts(forceRefresh: true);

      // Return true to indicate successful creation (posts will be refreshed)
      return true;
    } catch (e) {
      _setCreatingPost(false);
      // Still try to refresh in case the post was created despite the error
      await loadPosts(forceRefresh: true);
      print('Error creating post: $e');
      // Don't show error message, just log it
      return false;
    }
  }

  /// Refresh posts feed
  Future<void> refreshPosts() async {
    await loadPosts(forceRefresh: true);
  }

  /// Clear error message
  void clearError() {
    _setError(null);
  }
}
