import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../domain/models/onboarding_page.dart';

/// Widget that displays a single onboarding page content
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingXxl),

          // Image section
          _buildImageSection(),

          const SizedBox(height: AppConstants.spacingXxl),

          // Title section
          _buildTitleSection(theme),

          const SizedBox(height: AppConstants.spacingM),

          // Description section
          _buildDescriptionSection(theme),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child:
            page.image.endsWith('.riv')
                ? _buildRiveContainer()
                : _buildImageContainer(),
      ),
    );
  }

  Widget _buildRiveContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: const Icon(Icons.person, size: 120, color: AppColors.primary),
    );
  }

  Widget _buildImageContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      child: Image.asset(
        page.image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            child: const Icon(Icons.image, size: 120, color: AppColors.gray400),
          );
        },
      ),
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Text(
      page.title,
      style: theme.textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    return Expanded(
      flex: 1,
      child: Text(
        page.description,
        style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
