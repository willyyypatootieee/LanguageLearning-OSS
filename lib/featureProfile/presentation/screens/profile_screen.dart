import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../../shared/widgets/global_navbar.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../../featureAuthentication/data/repositories/auth_repository_impl.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_current_profile_usecase.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_widgets.dart';
import '../../../featureLeaderboard/presentation/widgets/leaderboard_provider.dart';

/// Profile screen showing user information and statistics
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _profileCubit;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeCubit();
    _loadProfile();
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

  Future<void> _loadProfile() async {
    await _profileCubit.loadProfile();
  }

  Future<void> _refreshProfile() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    await _profileCubit.refreshProfile();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  void dispose() {
    _profileCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _profileCubit,
          builder: (context, child) {
            // Only show loading spinner if there is no user data at all
            if (_profileCubit.user == null && _profileCubit.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            if (_profileCubit.error != null && _profileCubit.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: AppConstants.spacingL),
                    Text(
                      _profileCubit.error!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final user = _profileCubit.user;
            if (user == null) {
              return const Center(child: Text('No profile data available'));
            }

            return RefreshIndicator(
              onRefresh: _refreshProfile,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header section
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingL),
                      child: ProfileHeader(
                        username: user.username,
                        rank: user.currentRank,
                        onEditPressed: _onEditProfile,
                      ),
                    ),

                    // Overview section
                    ProfileSection(
                      title: 'Overview',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingL,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    icon: Icons.local_fire_department,
                                    label: 'Day Streak',
                                    value: user.streakDay.toString(),
                                    iconColor: Colors.orange,
                                    backgroundColor: Colors.orange.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacingM),
                                Expanded(
                                  child: ProfileStatCard(
                                    icon: Icons.bolt,
                                    label: 'Total Xp',
                                    value: user.totalXp.toString(),
                                    iconColor: Colors.purple,
                                    backgroundColor: Colors.purple.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spacingM),
                            Row(
                              children: [
                                Expanded(
                                  child: ProfileStatCard(
                                    icon: Icons.emoji_events,
                                    label: 'Current League',
                                    value: user.currentRank,
                                    iconColor: Colors.amber,
                                    backgroundColor: Colors.amber.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacingM),
                                Expanded(
                                  child: ProfileStatCard(
                                    icon: Icons.flag,
                                    label: 'English Score',
                                    value: user.scoreEnglish.toString(),
                                    iconColor: Colors.red,
                                    backgroundColor: Colors.red.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Additional spacing for navbar
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 4, // Profile tab index
        onTap: (index) {
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
            case 3:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => LeaderboardProvider(
                        currentIndex: index,
                        onNavTap: (int idx) {
                          Navigator.of(context).pop();
                          if (idx != 4) {
                            if (idx == 0) appRouter.goToHome();
                            if (idx == 1) appRouter.goToDictionary();
                            if (idx == 2)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Practice feature coming soon!',
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                ),
              );
              break;
            case 4:
              // Already on profile - do nothing
              break;
          }
        },
      ),
    );
  }
}
