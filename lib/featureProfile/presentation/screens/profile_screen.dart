import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../../shared/widgets/global_navbar.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../../featureAuthentication/data/repositories/auth_repository_impl.dart';
import '../../../featurePractice/data/datasources/practice_local_datasource.dart';
import '../../../featurePractice/data/repositories/practice_repository_impl.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_current_profile_usecase.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_widgets.dart';

/// Profile screen showing user information and statistics
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileCubit? _profileCubit;

  @override
  void initState() {
    super.initState();
    _initializeCubit();
    _loadProfile();
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
      print('Error initializing ProfileCubit: $e');
      // Set a fallback cubit or handle the error appropriately
    }
  }

  Future<void> _loadProfile() async {
    if (_profileCubit != null) {
      await _profileCubit!.loadProfile();
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Use the same logic as HomeScreen for logout
      final authRepository = AuthRepositoryImpl(
        AuthRemoteDataSource(),
        AuthLocalDataSource(),
      );
      await authRepository.clearAuthData();
      if (context.mounted) {
        appRouter.goToRoot();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
  void dispose() {
    _profileCubit?.dispose();
    super.dispose();
  }

  String _monthYear(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_profileCubit == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gray50, Colors.white, AppColors.gray50],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          child: const Center(
            child: Text(
              'Failed to initialize profile. Please restart the app.',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gray50, Colors.white, AppColors.gray50],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: ListenableBuilder(
          listenable: _profileCubit!,
          builder: (context, child) {
            final user = _profileCubit!.user;
            if (_profileCubit!.user == null && _profileCubit!.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_profileCubit!.error != null && user == null) {
              return Center(child: Text(_profileCubit!.error!));
            }
            if (user == null) {
              return const Center(child: Text('No profile data available'));
            }

            // Use CustomScrollView instead of SingleChildScrollView for better performance
            return CustomScrollView(
              // Use cacheExtent to improve scrolling performance
              cacheExtent: 800,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: ProfileHeader(
                    username: user.username,
                    handle: '@${user.username}',
                    joinDate: _monthYear(user.createdAt),
                    onSettingsPressed: () {},
                    onLogoutPressed: () => _logout(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ProfileInfoCard(
                    username: user.username,
                    handle: '@${user.username}',
                    joinDate: _monthYear(user.createdAt),
                    following: 69,
                    followers: 1700,
                    country: 'id',
                    countryLabel: 'Indonesia',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Action buttons
                      ProfileActionButtons(onAddFriends: null, onShare: () {}),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Overview section header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [AppColors.primary, AppColors.accent],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Overview',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.gray900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Use SliverPadding and SliverGrid for more efficient grid rendering
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      ProfileStatCard(
                        icon: Icons.local_fire_department,
                        label: 'Streak Hari Ini',
                        value: user.streakDay.toString(),
                        iconColor: Colors.deepOrange,
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.bolt,
                        label: 'Total Point',
                        value: user.totalXp.toString(),
                        iconColor: Colors.amber[600],
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.emoji_events,
                        label: 'Rank Saat Ini',
                        value: user.currentRank,
                        iconColor: Colors.purple[600],
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.flag,
                        label: 'Score Belajar',
                        value: user.scoreEnglish.toString(),
                        iconColor: Colors.green[600],
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 5,
        onTap: (index) {
          if (index == 5) return;
          switch (index) {
            case 0:
              appRouter.goToHome();
              break;
            case 1:
              appRouter.goToFeeds();
              break;
            case 2:
              appRouter.goToDictionary();
              break;
            case 3:
              _navigateToPractice();
              break;
            case 4:
              appRouter.goToLeaderboard();
              break;
          }
        },
      ),
    );
  }
}
