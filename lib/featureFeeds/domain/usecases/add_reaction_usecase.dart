import '../models/reaction.dart';
import '../repositories/post_repository.dart';

/// Use case for adding a reaction to a post
class AddReactionUsecase {
  final PostRepository _repository;

  AddReactionUsecase(this._repository);

  /// Execute the use case to add a reaction to a post
  ///
  /// Returns the created Reaction if successful, null otherwise
  Future<Reaction?> call(String postId, String emotion) async {
    try {
      return await _repository.addReaction(postId, emotion);
    } catch (e) {
      print('Error in AddReactionUsecase: $e');
      return null;
    }
  }
}
