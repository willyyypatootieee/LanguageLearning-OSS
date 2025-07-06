import '../models/post.dart';
import '../repositories/post_repository.dart';

/// Use case for getting a post by ID with replies
class GetPostByIdUsecase {
  final PostRepository _repository;

  GetPostByIdUsecase(this._repository);

  /// Execute the use case to get a post by ID
  Future<Post?> call(String postId) async {
    try {
      return await _repository.getPostById(postId);
    } catch (e) {
      print('Error in GetPostByIdUsecase: $e');
      return null;
    }
  }
}
