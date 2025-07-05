/// Use case for accepting a friend request
class AcceptFriendRequestUsecase {
  Future<void> call(String requestId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In real implementation, this would call:
    // POST /api/friends/{requestId}/accept
    print('Accepting friend request: $requestId');
  }
}
