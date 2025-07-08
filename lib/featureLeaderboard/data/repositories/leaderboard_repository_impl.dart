import '../../domain/models/leaderboard_user.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_datasource.dart';
import '../datasources/leaderboard_local_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  final LeaderboardLocalDataSource localDataSource;

  LeaderboardRepositoryImpl(this.remoteDataSource, this.localDataSource);
  @override
  Future<List<LeaderboardUser>> getLeaderboardUsers({
    bool forceRefresh = false,
  }) async {
    try {
      // Check if we can use cached data
      if (!forceRefresh) {
        final isCacheValid = await localDataSource.isCacheValid();

        if (isCacheValid) {
          final cachedUsers = await localDataSource.getCachedLeaderboardUsers();
          if (cachedUsers != null && cachedUsers.isNotEmpty) {
            print(
              'DEBUG: Using cached leaderboard data (${cachedUsers.length} users)',
            );
            return cachedUsers;
          }
        }
      }

      // If cache is invalid or we're forcing a refresh, get from remote
      print('DEBUG: Fetching leaderboard from remote');
      final users = await remoteDataSource.fetchLeaderboardUsers();

      print(
        'DEBUG: Successfully fetched ${users.length} users for leaderboard',
      );
      if (users.isNotEmpty) {
        // Log a sample user to debug parsing issues
        final firstUser = users.first;
        print(
          'DEBUG: Sample user - username: ${firstUser.username}, points: ${firstUser.totalPoint}, rank: ${firstUser.currentRank}',
        );
      }

      // Cache the new data
      await localDataSource.cacheLeaderboardUsers(users);

      return users;
    } catch (e) {
      print('DEBUG: Exception in repository getLeaderboardUsers: $e');

      // Try to return cached data even if expired as fallback
      final cachedUsers = await localDataSource.getCachedLeaderboardUsers();
      if (cachedUsers != null && cachedUsers.isNotEmpty) {
        print(
          'DEBUG: Returning expired cached leaderboard due to error (${cachedUsers.length} users)',
        );
        return cachedUsers;
      }

      print(
        'DEBUG: No cached leaderboard data available to recover from error',
      );
      // If no cached data is available, rethrow the error
      rethrow;
    }
  }
}
