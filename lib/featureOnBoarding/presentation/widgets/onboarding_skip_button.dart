import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Widget that displays the skip button for onboarding
class OnboardingSkipButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onSkip;

  const OnboardingSkipButton({
    super.key,
    required this.isVisible,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isVisible) {
      return const SizedBox(height: 56);
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: TextButton(
          onPressed: onSkip,
          child: Text(
            'Skip',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.gray600,
            ),
          ),
        ),
      ),
    );
  }
}
