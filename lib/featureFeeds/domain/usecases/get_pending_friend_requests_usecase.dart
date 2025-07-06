import '../models/friend_request.dart';

/// Use case for getting pending friend requests
class GetPendingFriendRequestsUsecase {
  Future<List<FriendRequest>> call() async {
    // This would be replaced with an actual API call in production
    await Future.delayed(const Duration(milliseconds: 300));

    // Return empty list - would be populated from API in production
    return [];
  }
}
