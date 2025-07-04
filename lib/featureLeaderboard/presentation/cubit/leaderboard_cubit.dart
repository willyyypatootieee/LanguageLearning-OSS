import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/leaderboard_user.dart';
import '../../domain/usecases/get_leaderboard_users_usecase.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboardUsersUseCase getLeaderboardUsersUseCase;

  LeaderboardCubit(this.getLeaderboardUsersUseCase)
    : super(LeaderboardInitial());

  Future<void> fetchLeaderboard({bool forceRefresh = false}) async {
    emit(LeaderboardLoading());
    try {
      final users = await getLeaderboardUsersUseCase(
        forceRefresh: forceRefresh,
      );
      final rankedUsers = _assignRanks(users);
      emit(LeaderboardLoaded(rankedUsers));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  List<LeaderboardUser> _assignRanks(List<LeaderboardUser> users) {
    final sorted = List<LeaderboardUser>.from(users)
      ..sort((a, b) => b.totalPoint.compareTo(a.totalPoint));
    for (int i = 0; i < sorted.length; i++) {
      String rank;
      if (i == 0) {
        rank = 'Diamond';
      } else if (i == 1) {
        rank = 'Gold';
      } else if (i == 2) {
        rank = 'Bronze';
      } else if (i < 10) {
        rank = 'Wood';
      } else {
        rank = 'Unranked';
      }
      sorted[i] = LeaderboardUser(
        id: sorted[i].id,
        username: sorted[i].username,
        totalPoint: sorted[i].totalPoint,
        currentRank: rank,
      );
    }
    return sorted;
  }
}
