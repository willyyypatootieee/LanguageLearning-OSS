import '../repositories/post_repository.dart';

/// Use case for removing a reaction from a post
class RemoveReactionUsecase {
  final PostRepository _repository;

  RemoveReactionUsecase(this._repository);

  /// Execute the use case to remove a reaction from a post
  ///
  /// Returns true if successful, false otherwise
  Future<bool> call(String postId) async {
    try {
      return await _repository.removeReaction(postId);
    } catch (e) {
      print('Error in RemoveReactionUsecase: $e');
      return false;
    }
  }
}
