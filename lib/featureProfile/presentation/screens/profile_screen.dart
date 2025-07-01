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
import '../../../featureHomeScreen/presentation/screens/home_screen.dart';
import '../../../featureDictionary/screens/ipa_chart_screen.dart';

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

  @override
  void dispose() {
    _profileCubit.dispose();
    super.dispose();
  }

  String _monthYear(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
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
          listenable: _profileCubit,
          builder: (context, child) {
            final user = _profileCubit.user;
            if (_profileCubit.user == null && _profileCubit.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_profileCubit.error != null && user == null) {
              return Center(child: Text(_profileCubit.error!));
            }
            if (user == null) {
              return const Center(child: Text('No profile data available'));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile header with avatar
                  ProfileHeader(
                    username: user.username,
                    handle: '@${user.username}',
                    joinDate: _monthYear(user.createdAt),
                    onSettingsPressed: () {},
                    onLogoutPressed: () => _logout(context),
                  ),
                  // Profile info card (overlapping the header)
                  ProfileInfoCard(
                    username: user.username,
                    handle: '@${user.username}',
                    joinDate: _monthYear(user.createdAt),
                    following: 69,
                    followers: 1700,
                    country: 'id',
                    countryLabel: 'Indonesia',
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  ProfileActionButtons(
                    onAddFriends: null, // Remove Add Friends button
                    onShare: () {},
                  ),
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
                  const SizedBox(height: 16),
                  // Stats grid with improved layout
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      ProfileStatCard(
                        icon: Icons.local_fire_department,
                        label: 'Day Streak',
                        value: user.streakDay.toString(),
                        iconColor: Colors.deepOrange,
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.bolt,
                        label: 'Total XP',
                        value: user.totalXp.toString(),
                        iconColor: Colors.amber[600],
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.emoji_events,
                        label: 'Current League',
                        value: user.currentRank,
                        iconColor: Colors.purple[600],
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.flag,
                        label: 'English Score',
                        value: user.scoreEnglish.toString(),
                        iconColor: Colors.green[600],
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  // Add bottom padding to account for floating navbar
                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
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
              appRouter.goToLeaderboard();
              break;
          }
        },
      ),
    );
  }
}
