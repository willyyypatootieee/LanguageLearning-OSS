/// Use case for rejecting a friend request
class RejectFriendRequestUsecase {
  Future<void> call(String requestId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In real implementation, this would call:
    // POST /api/friends/{requestId}/reject
    print('Rejecting friend request: $requestId');
  }
}
