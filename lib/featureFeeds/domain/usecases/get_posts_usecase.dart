import '../models/post.dart';
import '../repositories/post_repository.dart';

/// Use case for getting posts feed
class GetPostsUsecase {
  final PostRepository _repository;

  GetPostsUsecase(this._repository);

  /// Execute the use case to get posts
  /// If [forceRefresh] is true, it will ignore cache and fetch from the server
  Future<List<Post>> call({bool forceRefresh = false}) async {
    try {
      return await _repository.getPosts(forceRefresh: forceRefresh);
    } catch (e) {
      return [];
    }
  }
}
