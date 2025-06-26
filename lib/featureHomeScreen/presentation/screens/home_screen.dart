import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../router/router_exports.dart';
import '../../../shared/shared_exports.dart';

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
    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation based on index
    switch (index) {
      case 0:
        // Already on home - do nothing
        break;
      case 1:
        // Navigate to learning section
        // TODO: Implement navigation to learning screen
        break;
      case 2:
        // Navigate to practice section
        // TODO: Implement navigation to practice screen
        break;
      case 3:
        // Navigate to leaderboard
        // TODO: Implement navigation to leaderboard screen
        break;
      case 4:
        // Navigate to profile
        // TODO: Implement navigation to profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('BeLing'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apps, size: 64, color: AppColors.primary),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'BeLing App',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'Welcome to your language learning journey!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
