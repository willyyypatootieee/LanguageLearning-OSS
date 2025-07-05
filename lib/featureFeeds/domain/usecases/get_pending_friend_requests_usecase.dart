import '../models/friend_request.dart';

/// Use case for getting pending friend requests
class GetPendingFriendRequestsUsecase {
  Future<List<FriendRequest>> call() async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      FriendRequest(
        id: '1',
        userId: 'user_123',
        friendId: 'friend_456',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FriendRequest(
        id: '2',
        userId: 'user_789',
        friendId: 'current_user',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
