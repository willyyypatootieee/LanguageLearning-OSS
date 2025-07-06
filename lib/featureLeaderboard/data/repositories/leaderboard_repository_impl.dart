import '../../domain/models/leaderboard_user.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;
  List<LeaderboardUser>? _cache;

  LeaderboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LeaderboardUser>> getLeaderboardUsers({
    bool forceRefresh = false,
  }) async {
    // Always fetch fresh data if forceRefresh is true or if cache is null
    if (forceRefresh || _cache == null) {
      try {
        final users = await remoteDataSource.fetchLeaderboardUsers();
        _cache = users;
        return users;
      } catch (e) {
        // If fetch fails but we have cached data, return that as fallback
        if (_cache != null) {
          return _cache!;
        }
        // Otherwise rethrow the error
        rethrow;
      }
    }
    return _cache!;
  }
}
