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
    // Only show loading state if we're forcing a refresh or starting from initial state
    if (state is LeaderboardInitial || forceRefresh) {
      emit(LeaderboardLoading());
    }

    try {
      final users = await getLeaderboardUsersUseCase(
        forceRefresh: forceRefresh,
      );
      final rankedUsers = _assignRanks(users);
      emit(LeaderboardLoaded(rankedUsers));
    } catch (e) {
      // Only emit error if we don't already have data to show
      if (state is! LeaderboardLoaded) {
        emit(LeaderboardError(e.toString()));
      } else {
        // Log error but keep showing existing data
        print('Error refreshing leaderboard: $e');
      }
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
