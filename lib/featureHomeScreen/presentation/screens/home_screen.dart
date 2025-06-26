import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Main home screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
