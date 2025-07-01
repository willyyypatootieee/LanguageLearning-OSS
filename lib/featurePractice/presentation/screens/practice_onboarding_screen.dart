import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../../data/constants/practice_constants.dart';
import '../../data/datasources/practice_local_datasource.dart';
import '../../data/repositories/practice_repository_impl.dart';
import '../../domain/repositories/practice_repository.dart';
import '../widgets/practice_onboarding_widgets.dart';

/// Practice feature onboarding screen
class PracticeOnboardingScreen extends StatefulWidget {
  const PracticeOnboardingScreen({super.key});

  @override
  State<PracticeOnboardingScreen> createState() =>
      _PracticeOnboardingScreenState();
}

class _PracticeOnboardingScreenState extends State<PracticeOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Repository instance
  late final PracticeRepository _repository;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _repository = PracticeRepositoryImpl(PracticeLocalDataSource());

    // Initialize animations
    _fadeController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: AppConstants.animationNormal,
      vsync: this,
    );

    // Start entrance animation
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _completePracticeOnboarding() async {
    await _repository.completePracticeOnboarding();
    if (mounted) {
      // Navigate to practice main screen
      appRouter.push('/practice');
    }
  }

  void _nextPage() {
    if (_currentPage < PracticeConstants.onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOut,
      );
    } else {
      _completePracticeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppConstants.animationNormal,
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
        child: FadeTransition(
          opacity: _fadeController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _slideController,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Column(
              children: [
                // Skip button
                PracticeOnboardingSkipButton(
                  isVisible:
                      _currentPage <
                      PracticeConstants.onboardingPages.length - 1,
                  onSkip: _completePracticeOnboarding,
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: PracticeConstants.onboardingPages.length,
                    itemBuilder: (context, index) {
                      return PracticeOnboardingPageWidget(
                        page: PracticeConstants.onboardingPages[index],
                      );
                    },
                  ),
                ),

                // Page indicators and navigation
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingL,
                    vertical: AppConstants.spacingM,
                  ),
                  child: Column(
                    children: [
                      // Page indicators
                      PracticeOnboardingIndicators(
                        currentPage: _currentPage,
                        totalPages: PracticeConstants.onboardingPages.length,
                        activeColor:
                            PracticeConstants
                                .onboardingPages[_currentPage]
                                .primaryColor,
                      ),

                      const SizedBox(height: AppConstants.spacingL),

                      // Navigation buttons
                      Row(
                        children: [
                          // Back button
                          if (_currentPage > 0)
                            Expanded(
                              child: PracticeOnboardingButton(
                                text: 'Back',
                                onPressed: _previousPage,
                                isSecondary: true,
                              ),
                            ),

                          if (_currentPage > 0)
                            const SizedBox(width: AppConstants.spacingM),

                          // Next/Get Started button
                          Expanded(
                            flex: _currentPage == 0 ? 1 : 1,
                            child: PracticeOnboardingButton(
                              text:
                                  _currentPage ==
                                          PracticeConstants
                                                  .onboardingPages
                                                  .length -
                                              1
                                      ? 'Start Practicing!'
                                      : 'Next',
                              onPressed: _nextPage,
                              backgroundColor:
                                  PracticeConstants
                                      .onboardingPages[_currentPage]
                                      .primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
