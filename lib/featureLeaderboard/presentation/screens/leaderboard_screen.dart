import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/leaderboard_cubit.dart';
import '../../domain/models/leaderboard_user.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/shared_exports.dart';
import '../../../router/router_exports.dart';
import '../widgets/bento_leaderboard_widgets.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../../featureAuthentication/data/repositories/auth_repository_impl.dart';
import '../../../featureProfile/data/datasources/profile_local_datasource.dart';
import '../../../featureProfile/data/datasources/profile_remote_datasource.dart';
import '../../../featureProfile/data/repositories/profile_repository_impl.dart';
import '../../../featureProfile/domain/usecases/get_current_profile_usecase.dart';
import '../../../featureProfile/presentation/cubit/profile_cubit.dart';

class LeaderboardScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavTap;
  const LeaderboardScreen({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final ProfileCubit _profileCubit;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _initializeCubit();
    _loadCurrentUser();
  }

  void _initializeCubit() {
    // Initialize repositories and use cases
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSource(),
      AuthLocalDataSource(),
    );

    final profileRepository = ProfileRepositoryImpl(
      ProfileRemoteDataSource(),
      ProfileLocalDataSource(),
      authRepository,
    );

    final getCurrentProfileUseCase = GetCurrentProfileUseCase(
      profileRepository,
    );

    _profileCubit = ProfileCubit(getCurrentProfileUseCase, profileRepository);
  }

  Future<void> _loadCurrentUser() async {
    await _profileCubit.loadProfile();
    if (_profileCubit.user != null) {
      setState(() {
        _currentUsername = _profileCubit.user!.username;
      });
    }
  }

  @override
  void dispose() {
    _profileCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.gray900,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.gray200,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gray50, Colors.white, AppColors.gray50],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            } else if (state is LeaderboardLoaded) {
              final users = state.users;
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.leaderboard,
                        size: 80,
                        color: AppColors.gray400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No leaderboard data available',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.gray600,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Split users into top 3 and rest
              final top3 = users.take(3).toList();
              final rest = users.skip(3).toList();

              // Group users by rank type
              String getRankType(int pts) {
                if (pts == 0) return 'Unranked';
                if (pts > 85) return 'Wood+';
                if (pts > 60) return 'Wood';
                return 'Wood';
              }

              final Map<String, List<LeaderboardUser>> grouped = {
                'Wood+': [],
                'Wood': [],
                'Unranked': [],
              };

              for (final user in rest) {
                final type = getRankType(user.scoreEnglish);
                grouped[type]?.add(user);
              }

              // Find current user from profile
              String currentUser = _currentUsername;

              return CustomScrollView(
                slivers: [
                  // Top 3 Bento Box
                  SliverToBoxAdapter(child: BentoTop3Widget(top3Users: top3)),

                  // Stats Overview
                  SliverToBoxAdapter(child: BentoStatsWidget(allUsers: users)),

                  // Rank sections
                  for (final rankType in ['Wood+', 'Wood', 'Unranked'])
                    if (grouped[rankType]!.isNotEmpty)
                      SliverToBoxAdapter(
                        child: BentoRankSectionWidget(
                          rankType: rankType,
                          users: grouped[rankType]!,
                          currentUsername: currentUser,
                        ),
                      ),

                  // Bottom padding for navbar
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              );
            } else if (state is LeaderboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading leaderboard',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.error,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.gray600,
                        fontFamily: 'Nunito',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<LeaderboardCubit>().fetchLeaderboard();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (index == widget.currentIndex) return;
          switch (index) {
            case 0:
              appRouter.goToHome();
              break;
            case 1:
              appRouter.goToDictionary();
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Practice feature coming soon!')),
              );
              break;
            case 4:
              appRouter.goToProfile();
              break;
          }
        },
      ),
    );
  }
}
