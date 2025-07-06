import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:experimental/featureLeaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:experimental/featureLeaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:experimental/featureLeaderboard/data/datasources/leaderboard_remote_datasource.dart';
import 'package:experimental/featureLeaderboard/data/repositories/leaderboard_repository_impl.dart';
import 'package:experimental/featureLeaderboard/domain/usecases/get_leaderboard_users_usecase.dart';

LeaderboardCubit? _leaderboardCubit;
LeaderboardRepositoryImpl? _leaderboardRepository;
LeaderboardRemoteDataSourceImpl? _leaderboardRemoteDataSource;
Dio? _dio;

class LeaderboardProvider extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavTap;
  const LeaderboardProvider({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  State<LeaderboardProvider> createState() => _LeaderboardProviderState();
}

class _LeaderboardProviderState extends State<LeaderboardProvider>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // Do not dispose cubit/repository to keep cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _dio ??= Dio();
    _leaderboardRemoteDataSource ??= LeaderboardRemoteDataSourceImpl(_dio!);
    _leaderboardRepository ??= LeaderboardRepositoryImpl(
      _leaderboardRemoteDataSource!,
    );
    _leaderboardCubit ??= LeaderboardCubit(
      GetLeaderboardUsersUseCase(_leaderboardRepository!),
    );
    return RepositoryProvider.value(
      value: _dio!,
      child: BlocProvider.value(
        value: _leaderboardCubit!..fetchLeaderboard(forceRefresh: true),
        child: LeaderboardScreen(
          currentIndex: widget.currentIndex,
          onNavTap: widget.onNavTap,
        ),
      ),
    );
  }
}
