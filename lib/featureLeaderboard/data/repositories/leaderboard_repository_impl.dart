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
    if (!forceRefresh && _cache != null) {
      return _cache!;
    }
    final users = await remoteDataSource.fetchLeaderboardUsers();
    _cache = users;
    return users;
  }
}
