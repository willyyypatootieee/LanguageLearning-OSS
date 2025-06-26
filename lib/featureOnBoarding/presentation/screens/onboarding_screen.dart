import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../data/constants/onboarding_constants.dart';
import '../../data/datasources/onboarding_local_datasource.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../widgets/widgets.dart';

/// Main onboarding screen that coordinates all onboarding components
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Repository instance
  late final OnboardingRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = OnboardingRepositoryImpl(OnboardingLocalDataSource());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await _repository.completeOnboarding();
    if (mounted) {
      appRouter.goToWelcome();
    }
  }

  void _nextPage() {
    if (_currentPage < OnboardingConstants.pages.length - 1) {
      _pageController.nextPage(
        duration: OnboardingConstants.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: OnboardingConstants.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            OnboardingSkipButton(
              isVisible: _currentPage < OnboardingConstants.pages.length - 1,
              onSkip: _completeOnboarding,
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingConstants.pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    page: OnboardingConstants.pages[index],
                  );
                },
              ),
            ),

            // Page indicators
            OnboardingIndicators(
              currentPage: _currentPage,
              pages: OnboardingConstants.pages,
            ),

            const SizedBox(height: AppConstants.spacingXl),

            // Navigation buttons
            OnboardingNavigationButtons(
              currentPage: _currentPage,
              pages: OnboardingConstants.pages,
              onNext: _nextPage,
              onPrevious: _previousPage,
            ),

            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}
