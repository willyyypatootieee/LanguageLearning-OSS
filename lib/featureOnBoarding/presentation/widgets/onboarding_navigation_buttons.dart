import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_page.dart';
import '../../data/constants/onboarding_constants.dart';

/// Widget that displays navigation buttons for onboarding
class OnboardingNavigationButtons extends StatelessWidget {
  final int currentPage;
  final List<OnboardingPage> pages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const OnboardingNavigationButtons({
    super.key,
    required this.currentPage,
    required this.pages,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: OnboardingConstants.horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildPreviousButton(theme), _buildNextButton(theme)],
      ),
    );
  }

  Widget _buildPreviousButton(ThemeData theme) {
    if (currentPage <= 0) {
      return const SizedBox(width: 100);
    }

    return OutlinedButton(
      onPressed: onPrevious,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: pages[currentPage].backgroundColor),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OnboardingConstants.borderRadius),
        ),
      ),
      child: Text(
        'Previous',
        style: theme.textTheme.labelLarge?.copyWith(
          color: pages[currentPage].backgroundColor,
        ),
      ),
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    final isLastPage = currentPage == pages.length - 1;

    return ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: pages[currentPage].backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OnboardingConstants.borderRadius),
        ),
      ),
      child: Text(
        isLastPage ? 'Get Started' : 'Next',
        style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}
