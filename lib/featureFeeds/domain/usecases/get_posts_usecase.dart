import '../models/post.dart';
import '../repositories/post_repository.dart';

/// Use case for getting posts feed
class GetPostsUsecase {
  final PostRepository _repository;

  GetPostsUsecase(this._repository);

  /// Execute the use case to get posts
  Future<List<Post>> call() async {
    try {
      return await _repository.getPosts();
    } catch (e) {
      return [];
    }
  }
}
