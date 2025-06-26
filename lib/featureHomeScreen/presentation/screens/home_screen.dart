import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/service_locator.dart';
import '../../../router/router_exports.dart';

/// Main home screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
    );
  }
}
