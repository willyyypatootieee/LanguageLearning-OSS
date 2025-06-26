import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../data/constants/auth_constants.dart';

/// Error message component for authentication forms
class AuthErrorMessage extends StatelessWidget {
  final String? errorMessage;

  const AuthErrorMessage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Text(
            errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ),
        const SizedBox(height: AppConstants.spacingL),
      ],
    );
  }
}
