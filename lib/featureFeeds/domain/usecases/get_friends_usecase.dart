import '../models/friend.dart';

/// Use case for getting friends list
class GetFriendsUsecase {
  Future<List<Friend>> call() async {
    // This would be replaced with an actual API call in production
    await Future.delayed(const Duration(milliseconds: 500));

    // Return empty list - will be populated from API in production
    return [];
  }
}
