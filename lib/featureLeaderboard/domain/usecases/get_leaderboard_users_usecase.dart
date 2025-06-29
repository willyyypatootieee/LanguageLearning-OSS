import '../models/leaderboard_user.dart';
import '../repositories/leaderboard_repository.dart';

class GetLeaderboardUsersUseCase {
  final LeaderboardRepository repository;

  GetLeaderboardUsersUseCase(this.repository);

  Future<List<LeaderboardUser>> call({bool forceRefresh = false}) {
    return repository.getLeaderboardUsers(forceRefresh: forceRefresh);
  }
}
