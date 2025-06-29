import '../models/leaderboard_user.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardUser>> getLeaderboardUsers({
    bool forceRefresh = false,
  });
}
