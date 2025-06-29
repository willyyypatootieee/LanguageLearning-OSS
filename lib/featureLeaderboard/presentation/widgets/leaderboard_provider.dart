import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:experimental/featureLeaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:experimental/featureLeaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:experimental/featureLeaderboard/data/datasources/leaderboard_remote_datasource.dart';
import 'package:experimental/featureLeaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:experimental/featureLeaderboard/domain/usecases/get_leaderboard_users_usecase.dart';

class LeaderboardProvider extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavTap;
  const LeaderboardProvider({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => Dio(),
      child: BlocProvider(
        create: (context) {
          final dio = RepositoryProvider.of<Dio>(context);
          final remoteDataSource = LeaderboardRemoteDataSourceImpl(dio);
          final repository = LeaderboardRepositoryImpl(remoteDataSource);
          final usecase = GetLeaderboardUsersUseCase(repository);
          return LeaderboardCubit(usecase)..fetchLeaderboard();
        },
        child: LeaderboardScreen(
          currentIndex: currentIndex,
          onNavTap: onNavTap,
        ),
      ),
    );
  }
}
