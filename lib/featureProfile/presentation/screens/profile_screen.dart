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
      backgroundColor: AppColors.gray50,
      body: SafeArea(
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
            return Column(
              children: [
                ProfileHeader(
                  username: user.username,
                  handle: '@${user.username}',
                  joinDate: _monthYear(user.createdAt),
                  onSettingsPressed: () {},
                  onLogoutPressed: () => _logout(context),
                ),
                ProfileInfoCard(
                  username: user.username,
                  handle: '@${user.username}',
                  joinDate: _monthYear(user.createdAt),
                  following: 69,
                  followers: 1700,
                  country: 'id',
                  countryLabel: 'Indonesia',
                ),
                ProfileActionButtons(
                  onAddFriends: null, // Remove Add Friends button
                  onShare: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.7,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      ProfileStatCard(
                        icon: Icons.local_fire_department,
                        label: 'Day Streak',
                        value: user.streakDay.toString(),
                        iconColor: Colors.orange,
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.bolt,
                        label: 'Total Xp',
                        value: user.totalXp.toString(),
                        iconColor: Colors.amber,
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.emoji_events,
                        label: 'Current League',
                        value: user.currentRank,
                        iconColor: Colors.amber,
                        backgroundColor: Colors.white,
                      ),
                      ProfileStatCard(
                        icon: Icons.flag,
                        label: 'English Score',
                        value: user.scoreEnglish.toString(),
                        iconColor: Colors.red,
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
