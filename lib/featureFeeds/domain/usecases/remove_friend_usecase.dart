/// Use case for removing a friend
class RemoveFriendUsecase {
  Future<void> call(String friendId) async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In real implementation, this would call:
    // DELETE /api/friends/{friendId}
    print('Removing friend: $friendId');
  }
}
