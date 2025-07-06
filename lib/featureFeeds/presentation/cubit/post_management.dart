import 'package:flutter/foundation.dart';
import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';
import '../../domain/models/reaction.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/add_reaction_usecase.dart';
import '../../domain/usecases/remove_reaction_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/get_reactions_usecase.dart';
import 'feed_state.dart';

mixin PostManagement on ChangeNotifier {
  GetPostsUsecase? _getPostsUsecase;
  CreatePostUsecase? _createPostUsecase;
  DeletePostUsecase? _deletePostUsecase;
  AddReactionUsecase? _addReactionUsecase;
  RemoveReactionUsecase? _removeReactionUsecase;
  GetPostByIdUsecase? _getPostByIdUsecase;
  GetReactionsUsecase? _getReactionsUsecase;
  late FeedState state;

  set getPostsUsecase(GetPostsUsecase usecase) => _getPostsUsecase = usecase;
  set createPostUsecase(CreatePostUsecase usecase) =>
      _createPostUsecase = usecase;
  set deletePostUsecase(DeletePostUsecase usecase) =>
      _deletePostUsecase = usecase;
  set addReactionUsecase(AddReactionUsecase usecase) =>
      _addReactionUsecase = usecase;
  set removeReactionUsecase(RemoveReactionUsecase usecase) =>
      _removeReactionUsecase = usecase;
  set getPostByIdUsecase(GetPostByIdUsecase usecase) =>
      _getPostByIdUsecase = usecase;
  set getReactionsUsecase(GetReactionsUsecase usecase) =>
      _getReactionsUsecase = usecase;

  Future<void> loadPosts({bool forceRefresh = false}) async {
    if (state.hasInitiallyLoaded && !forceRefresh) {
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      if (_getPostsUsecase == null)
        throw Exception('GetPostsUsecase not initialized');
      final posts = await _getPostsUsecase!();
      state = state.copyWith(
        originalPosts: posts,
        hasInitiallyLoaded: true,
        isLoading: false,
      );
      _applyCurrentFilters();
    } catch (e) {
      print('Error loading posts in cubit: $e');
      state = state.copyWith(isLoading: false, hasInitiallyLoaded: true);
    }
    notifyListeners();
  }

  Future<bool> createPost(
    String content, {
    String? imageUrl,
    String? parentId,
  }) async {
    if (content.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: () => 'Post content cannot be empty',
      );
      notifyListeners();
      return false;
    }

    state = state.copyWith(isCreatingPost: true, errorMessage: () => null);
    notifyListeners();

    try {
      if (_createPostUsecase == null)
        throw Exception('CreatePostUsecase not initialized');
      final request = CreatePostRequest(
        content: content.trim(),
        imageUrl: imageUrl,
        parentId: parentId,
      );

      await _createPostUsecase!(request);
      state = state.copyWith(isCreatingPost: false);
      await loadPosts(forceRefresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(isCreatingPost: false);
      await loadPosts(forceRefresh: true);
      print('Error creating post: $e');
      return false;
    }
  }

  /// Reloads posts with force refresh.
  /// This is used by the pull-to-refresh functionality in the feed.
  Future<void> refreshPosts() async {
    await loadPosts(forceRefresh: true);
  }

  void _applyCurrentFilters() {
    List<Post> filteredPosts = List.from(state.originalPosts);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filteredPosts =
          filteredPosts.where((post) {
            final contentMatch = post.content.toLowerCase().contains(
              state.searchQuery,
            );
            final authorMatch = post.author.username.toLowerCase().contains(
              state.searchQuery,
            );
            final rankMatch = post.author.currentRank.toLowerCase().contains(
              state.searchQuery,
            );
            return contentMatch || authorMatch || rankMatch;
          }).toList();
    }

    // Apply rank filter
    if (state.currentFilters['rank'] != null &&
        state.currentFilters['rank'] != 'Semua') {
      String rankFilter = state.currentFilters['rank'];
      Map<String, String> rankMapping = {
        'Pemula': 'BEGINNER',
        'Perunggu': 'BRONZE',
        'Perak': 'SILVER',
        'Emas': 'GOLD',
        'Platinum': 'PLATINUM',
        'Berlian': 'DIAMOND',
      };

      String englishRank = rankMapping[rankFilter] ?? rankFilter.toUpperCase();
      filteredPosts =
          filteredPosts
              .where(
                (post) => post.author.currentRank.toUpperCase() == englishRank,
              )
              .toList();
    }

    // Apply sorting
    String sortOption = state.currentFilters['sort'] ?? 'Terbaru';
    switch (sortOption) {
      case 'Terbaru':
        filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Terpopuler':
        filteredPosts.sort((a, b) {
          int aReactions =
              a.reactionsCount?.values.fold<int>(
                0,
                (sum, count) => sum + count,
              ) ??
              0;
          int bReactions =
              b.reactionsCount?.values.fold<int>(
                0,
                (sum, count) => sum + count,
              ) ??
              0;
          return bReactions.compareTo(aReactions);
        });
        break;
      case 'XP Tertinggi':
        filteredPosts.sort(
          (a, b) => b.author.totalXp.compareTo(a.author.totalXp),
        );
        break;
      case 'Streak Terpanjang':
        filteredPosts.sort(
          (a, b) => b.author.streakDay.compareTo(a.author.streakDay),
        );
        break;
    }

    state = state.copyWith(posts: filteredPosts);
    notifyListeners();
  }

  void searchPosts(String query) {
    state = state.copyWith(searchQuery: query.trim().toLowerCase());
    _applyCurrentFilters();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    _applyCurrentFilters();
  }

  void applyFilters(Map<String, dynamic> filters) {
    state = state.copyWith(currentFilters: filters);
    _applyCurrentFilters();
  }

  /// Delete a post by ID
  Future<bool> deletePost(String postId) async {
    if (_deletePostUsecase == null) {
      throw Exception('DeletePostUsecase not initialized');
    }

    state = state.copyWith(isLoading: true, errorMessage: () => null);
    notifyListeners();

    try {
      final result = await _deletePostUsecase!(postId);

      if (result) {
        // Update posts list after successful deletion
        state = state.copyWith(
          originalPosts:
              state.originalPosts.where((post) => post.id != postId).toList(),
          isLoading: false,
        );
        _applyCurrentFilters();
        notifyListeners();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => 'Failed to delete post',
        );
        notifyListeners();
      }

      return result;
    } catch (e) {
      print('Error deleting post in cubit: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Error deleting post: ${e.toString()}',
      );
      notifyListeners();
      return false;
    }
  }

  /// Add reaction to a post
  Future<Reaction?> addReaction(String postId, String emotion) async {
    if (_addReactionUsecase == null) {
      throw Exception('AddReactionUsecase not initialized');
    }

    try {
      final reaction = await _addReactionUsecase!(postId, emotion);

      if (reaction != null) {
        // Refresh the post to get updated reactions count
        await _refreshPost(postId);
      }

      return reaction;
    } catch (e) {
      print('Error adding reaction in cubit: $e');
      return null;
    }
  }

  /// Remove reaction from a post
  Future<bool> removeReaction(String postId) async {
    if (_removeReactionUsecase == null) {
      throw Exception('RemoveReactionUsecase not initialized');
    }

    try {
      final result = await _removeReactionUsecase!(postId);

      if (result) {
        // Refresh the post to get updated reactions count
        await _refreshPost(postId);
      }

      return result;
    } catch (e) {
      print('Error removing reaction in cubit: $e');
      return false;
    }
  }

  /// Get a post by ID with all of its replies
  Future<Post?> getPostById(String postId) async {
    if (_getPostByIdUsecase == null) {
      throw Exception('GetPostByIdUsecase not initialized');
    }

    try {
      final post = await _getPostByIdUsecase!(postId);
      return post;
    } catch (e) {
      print('Error getting post by ID in cubit: $e');
      return null;
    }
  }

  /// Get all reactions for a post
  Future<List<Reaction>> getReactions(String postId) async {
    if (_getReactionsUsecase == null) {
      throw Exception('GetReactionsUsecase not initialized');
    }

    try {
      final reactions = await _getReactionsUsecase!(postId);
      return reactions;
    } catch (e) {
      print('Error getting reactions in cubit: $e');
      return [];
    }
  }

  /// Helper method to refresh a post after reaction changes
  Future<void> _refreshPost(String postId) async {
    if (_getPostByIdUsecase == null) {
      return;
    }

    try {
      final updatedPost = await _getPostByIdUsecase!(postId);
      if (updatedPost == null) return;

      final updatedPosts =
          state.originalPosts.map((post) {
            return post.id == postId ? updatedPost : post;
          }).toList();

      state = state.copyWith(originalPosts: updatedPosts);
      _applyCurrentFilters();
      notifyListeners();
    } catch (e) {
      print('Error refreshing post in cubit: $e');
    }
  }
}
