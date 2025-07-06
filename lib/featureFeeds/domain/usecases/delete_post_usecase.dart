import '../repositories/post_repository.dart';

/// Use case for deleting a post
class DeletePostUsecase {
  final PostRepository _repository;

  DeletePostUsecase(this._repository);

  /// Execute the use case to delete a post
  ///
  /// Returns true if successful, false otherwise
  Future<bool> call(String postId) async {
    try {
      return await _repository.deletePost(postId);
    } catch (e) {
      print('Error in DeletePostUsecase: $e');
      return false;
    }
  }
}
