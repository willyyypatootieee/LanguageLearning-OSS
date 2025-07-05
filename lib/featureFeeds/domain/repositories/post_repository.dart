import '../models/post.dart';
import '../models/post_request.dart';

/// Abstract repository interface for posts
abstract class PostRepository {
  /// Get posts feed from the user and their friends
  Future<List<Post>> getPosts();

  /// Create a new post
  Future<Post?> createPost(CreatePostRequest request);
}
