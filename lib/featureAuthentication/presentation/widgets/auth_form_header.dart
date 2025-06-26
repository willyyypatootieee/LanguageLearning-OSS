import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Header component for authentication forms
class AuthFormHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.spacingXxl),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: AppConstants.spacingXs),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
        ),
        const SizedBox(height: AppConstants.spacingXxl),
      ],
    );
  }
}
