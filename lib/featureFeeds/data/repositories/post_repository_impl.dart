import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';
import '../../domain/models/reaction.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';
import '../datasources/post_local_datasource.dart';

/// Implementation of PostRepository
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final PostLocalDataSource _localDataSource;

  PostRepositoryImpl(this._remoteDataSource, this._localDataSource);
  @override
  Future<List<Post>> getPosts({bool forceRefresh = false}) async {
    try {
      // Check if we can use cached data
      if (!forceRefresh) {
        final isCacheValid = await _localDataSource.isCacheValid();

        if (isCacheValid) {
          final cachedPosts = await _localDataSource.getCachedPosts();
          if (cachedPosts != null && cachedPosts.isNotEmpty) {
            print('DEBUG: Using cached posts data');
            print('DEBUG: Successfully parsed ${cachedPosts.length} posts');
            return cachedPosts;
          }
        }
      }

      // If cache is invalid or we're forcing a refresh, get from remote
      print('DEBUG: Fetching posts from remote');
      final posts = await _remoteDataSource.getPosts();

      // Additional debug logging to help diagnose parsing issues
      print('DEBUG: Successfully parsed ${posts.length} posts');
      if (posts.isNotEmpty) {
        // Check for problematic fields that might cause issues
        final firstPost = posts.first;
        print('DEBUG: Post author totalXp: ${firstPost.author.totalXp}');
        print('DEBUG: Post author username: ${firstPost.author.username}');
        print(
          'DEBUG: Post author currentRank: ${firstPost.author.currentRank}',
        );
      }

      // Cache the new data
      await _localDataSource.cachePosts(posts);

      return posts;
    } catch (e) {
      print('DEBUG: Exception in repository getPosts: $e');

      // Try to return cached data even if expired as fallback
      final cachedPosts = await _localDataSource.getCachedPosts();
      if (cachedPosts != null && cachedPosts.isNotEmpty) {
        print('DEBUG: Returning expired cached posts due to error');
        print('DEBUG: Cached posts count: ${cachedPosts.length}');
        return cachedPosts;
      }

      return [];
    }
  }

  @override
  Future<Post?> createPost(CreatePostRequest request) async {
    try {
      // For POST requests, we need the user ID
      final userId = await _localDataSource.getUserId();
      if (userId == null) {
        print('DEBUG: Cannot create post - User ID is null');
        return null;
      }

      return await _remoteDataSource.createPost(request, userId);
    } catch (e) {
      print('DEBUG: Exception in repository createPost: $e');
      return null;
    }
  }

  @override
  Future<Post?> getPostById(String postId) async {
    try {
      return await _remoteDataSource.getPostById(postId);
    } catch (e) {
      print('DEBUG: Exception in repository getPostById: $e');
      return null;
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    try {
      // We need the user ID to verify ownership
      final userId = await _localDataSource.getUserId();
      if (userId == null) {
        print('DEBUG: Cannot delete post - User ID is null');
        return false;
      }

      return await _remoteDataSource.deletePost(postId, userId);
    } catch (e) {
      print('DEBUG: Exception in repository deletePost: $e');
      return false;
    }
  }

  @override
  Future<Reaction?> addReaction(String postId, String emotion) async {
    try {
      // We need the user ID for the reaction
      final userId = await _localDataSource.getUserId();
      if (userId == null) {
        print('DEBUG: Cannot add reaction - User ID is null');
        return null;
      }

      return await _remoteDataSource.addReaction(postId, emotion, userId);
    } catch (e) {
      print('DEBUG: Exception in repository addReaction: $e');
      return null;
    }
  }

  @override
  Future<bool> removeReaction(String postId) async {
    try {
      // We need the user ID to identify which reaction to remove
      final userId = await _localDataSource.getUserId();
      if (userId == null) {
        print('DEBUG: Cannot remove reaction - User ID is null');
        return false;
      }

      return await _remoteDataSource.removeReaction(postId, userId);
    } catch (e) {
      print('DEBUG: Exception in repository removeReaction: $e');
      return false;
    }
  }

  @override
  Future<List<Reaction>> getReactions(String postId) async {
    try {
      return await _remoteDataSource.getReactions(postId);
    } catch (e) {
      print('DEBUG: Exception in repository getReactions: $e');
      return [];
    }
  }
}
