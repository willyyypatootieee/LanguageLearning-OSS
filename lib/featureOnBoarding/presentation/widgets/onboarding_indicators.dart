import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_page.dart';
import '../../data/constants/onboarding_constants.dart';

/// Widget that displays page indicators for onboarding
class OnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final List<OnboardingPage> pages;

  const OnboardingIndicators({
    super.key,
    required this.currentPage,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) => _buildIndicator(index)),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = currentPage == index;

    return AnimatedContainer(
      duration: OnboardingConstants.indicatorAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXs),
      width: isActive ? AppConstants.spacingXl : AppConstants.spacingS,
      height: AppConstants.spacingS,
      decoration: BoxDecoration(
        color:
            isActive ? pages[currentPage].backgroundColor : AppColors.gray300,
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
    );
  }
}
