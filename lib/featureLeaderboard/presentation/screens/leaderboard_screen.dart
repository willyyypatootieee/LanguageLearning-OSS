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
import '../../../featurePractice/data/datasources/practice_local_datasource.dart';
import '../../../featurePractice/data/repositories/practice_repository_impl.dart';

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
  ProfileCubit? _profileCubit;
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _initializeCubit();
    _loadCurrentUser();
  }

  void _initializeCubit() {
    try {
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
    } catch (e) {
      print('Error initializing ProfileCubit in LeaderboardScreen: $e');
      // Set a fallback or handle the error appropriately
    }
  }

  Future<void> _loadCurrentUser() async {
    if (_profileCubit != null) {
      await _profileCubit!.loadProfile();
      if (_profileCubit!.user != null) {
        setState(() {
          _currentUsername = _profileCubit!.user!.username;
        });
      }
    }
  }

  @override
  void dispose() {
    _profileCubit?.dispose();
    super.dispose();
  }

  Future<void> _navigateToPractice() async {
    try {
      final repository = PracticeRepositoryImpl(PracticeLocalDataSource());
      final hasCompletedOnboarding =
          await repository.isPracticeOnboardingCompleted();

      if (hasCompletedOnboarding) {
        appRouter.goToPractice();
      } else {
        appRouter.goToPracticeOnboarding();
      }
    } catch (e) {
      // If there's an error, go to onboarding
      appRouter.goToPracticeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.secondary,
                const Color(0xFFFFD54F), // Golden yellow
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Leaderboard',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Battle for the top spot! 🏆',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.flash_on_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Live',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
            colors: [
              AppColors.secondary.withValues(alpha: 0.1),
              Colors.white,
              AppColors.gray50,
            ],
            stops: const [0.0, 0.2, 1.0],
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
              _navigateToPractice();
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
