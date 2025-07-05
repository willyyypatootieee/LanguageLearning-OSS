import '../models/user_search_result.dart';

/// Use case for searching users
abstract class SearchUsersUsecase {
  Future<List<UserSearchResult>> call(String query);
}

class SearchUsersUsecaseImpl implements SearchUsersUsecase {
  @override
  Future<List<UserSearchResult>> call(String query) async {
    // Mock implementation for demonstration
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) return [];

    // Mock search results
    final mockUsers = [
      UserSearchResult(
        id: '1',
        username: 'admin_user',
        email: 'admin@example.com',
        totalXp: 2500,
        streakDay: 15,
        currentRank: 'GOLD',
        isFriend: false,
        hasPendingRequest: false,
      ),
      UserSearchResult(
        id: '2',
        username: 'john_admin',
        email: 'john@example.com',
        totalXp: 1800,
        streakDay: 8,
        currentRank: 'SILVER',
        isFriend: false,
        hasPendingRequest: false,
      ),
      UserSearchResult(
        id: '3',
        username: 'sarah_admin',
        email: 'sarah@example.com',
        totalXp: 3200,
        streakDay: 22,
        currentRank: 'PLATINUM',
        isFriend: true,
        hasPendingRequest: false,
      ),
      UserSearchResult(
        id: '4',
        username: 'mike_admin',
        email: 'mike@example.com',
        totalXp: 950,
        streakDay: 3,
        currentRank: 'BRONZE',
        isFriend: false,
        hasPendingRequest: true,
      ),
    ];

    return mockUsers
        .where(
          (user) => user.username.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
