import '../models/reaction.dart';
import '../repositories/post_repository.dart';

/// Use case for getting all reactions for a post
class GetReactionsUsecase {
  final PostRepository _repository;

  GetReactionsUsecase(this._repository);

  /// Execute the use case to get reactions for a post
  Future<List<Reaction>> call(String postId) async {
    try {
      return await _repository.getReactions(postId);
    } catch (e) {
      print('Error in GetReactionsUsecase: $e');
      return [];
    }
  }
}
