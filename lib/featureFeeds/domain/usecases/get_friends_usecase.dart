import '../models/friend.dart';

/// Use case for getting friends list
class GetFriendsUsecase {
  Future<List<Friend>> call() async {
    // Mock implementation - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Friend(
        id: '1',
        username: 'john_doe',
        email: 'john@example.com',
        scoreEnglish: 850,
        streakDay: 15,
        totalXp: 2500,
        currentRank: 'GOLD',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Friend(
        id: '2',
        username: 'jane_smith',
        email: 'jane@example.com',
        scoreEnglish: 920,
        streakDay: 22,
        totalXp: 3200,
        currentRank: 'PLATINUM',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
    ];
  }
}
