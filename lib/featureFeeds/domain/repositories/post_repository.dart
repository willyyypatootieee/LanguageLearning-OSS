import '../models/post.dart';
import '../models/post_request.dart';
import '../models/reaction.dart';

/// Abstract repository interface for posts
abstract class PostRepository {
  /// Get posts feed from the user and their friends
  Future<List<Post>> getPosts();

  /// Create a new post
  Future<Post?> createPost(CreatePostRequest request);

  /// Get a specific post by ID with replies
  Future<Post?> getPostById(String postId);

  /// Delete a post by ID (soft delete)
  Future<bool> deletePost(String postId);

  /// Add a reaction to a post
  Future<Reaction?> addReaction(String postId, String emotion);

  /// Remove a reaction from a post
  Future<bool> removeReaction(String postId);

  /// Get all reactions for a post
  Future<List<Reaction>> getReactions(String postId);
}
