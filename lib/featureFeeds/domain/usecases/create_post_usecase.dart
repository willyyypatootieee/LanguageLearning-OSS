import '../models/post.dart';
import '../models/post_request.dart';
import '../repositories/post_repository.dart';

/// Use case for creating a new post
class CreatePostUsecase {
  final PostRepository _repository;

  CreatePostUsecase(this._repository);

  /// Execute the use case to create a post
  Future<Post?> call(CreatePostRequest request) async {
    try {
      if (!request.isValid) {
        return null;
      }
      return await _repository.createPost(request);
    } catch (e) {
      return null;
    }
  }
}
