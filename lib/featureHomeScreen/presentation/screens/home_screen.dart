import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../router/router_exports.dart';
import '../../../shared/shared_exports.dart';
import '../../../featureLeaderboard/presentation/widgets/leaderboard_provider.dart';
import '../../../featureProfile/presentation/screens/profile_screen.dart';
import '../../../featureDictionary/screens/ipa_chart_screen.dart';

/// Main home screen of the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  Future<void> _logout(BuildContext context) async {
    try {
      final authRepository = ServiceLocator.instance.authRepository;
      await authRepository.clearAuthData();

      // Navigate back to root which will determine the correct route
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

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    switch (index) {
      case 0:
        appRouter.goToHome();
        break;
      case 1:
        appRouter.goToDictionary();
        break;
      case 2:
        // Navigate to practice section
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Practice feature coming soon!')),
        );
        break;
      case 3:
        appRouter.goToLeaderboard();
        break;
      case 4:
        appRouter.goToProfile();
        break;
    }
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Fullscreen background image
          Positioned.fill(
            child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
          ),
          // Logout button positioned at top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
