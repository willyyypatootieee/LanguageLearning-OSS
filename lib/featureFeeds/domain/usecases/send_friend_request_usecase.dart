import '../models/friend_request.dart';

/// Use case for sending friend requests
abstract class SendFriendRequestUsecase {
  Future<FriendRequest> call(String username);
}

class SendFriendRequestUsecaseImpl implements SendFriendRequestUsecase {
  @override
  Future<FriendRequest> call(String username) async {
    // Mock implementation for demonstration
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock friend request creation
    return FriendRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id',
      friendId: 'friend_user_id',
      status: 'PENDING',
      createdAt: DateTime.now(),
    );
  }
}
