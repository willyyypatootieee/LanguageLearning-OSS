import '../models/post_request.dart';
import '../repositories/post_repository.dart';

/// Use case for creating a reply to a post
class CreateReplyUsecase {
  final PostRepository _repository;

  CreateReplyUsecase(this._repository);

  /// Execute the use case to create a reply
  ///
  /// Returns true if successful, false otherwise
  Future<bool> call(String content, String parentId, {String? imageUrl}) async {
    try {
      final request = CreatePostRequest(
        content: content,
        imageUrl: imageUrl,
        parentId: parentId,
      );

      final result = await _repository.createPost(request);
      return result != null;
    } catch (e) {
      print('Error in CreateReplyUsecase: $e');
      return false;
    }
  }
}
