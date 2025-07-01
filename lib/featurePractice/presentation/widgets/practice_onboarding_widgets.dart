import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../data/constants/practice_constants.dart';

/// Skip button for practice onboarding
class PracticeOnboardingSkipButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onSkip;

  const PracticeOnboardingSkipButton({
    super.key,
    required this.isVisible,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: AppConstants.animationNormal,
            child: TextButton(
              onPressed: isVisible ? onSkip : null,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.gray500,
                  fontFamily: AppTypography.bodyFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual page widget for practice onboarding
class PracticeOnboardingPageWidget extends StatefulWidget {
  final PracticeOnboardingPage page;

  const PracticeOnboardingPageWidget({super.key, required this.page});

  @override
  State<PracticeOnboardingPageWidget> createState() =>
      _PracticeOnboardingPageWidgetState();
}

class _PracticeOnboardingPageWidgetState
    extends State<PracticeOnboardingPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppConstants.spacingL),

            // Animation/Illustration
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: widget.page.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                ),
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: widget.page.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      size: 64,
                      color: widget.page.primaryColor,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingL),

            // Title
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.page.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTypography.headerFont,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingM),

            // Subtitle
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.page.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTypography.bodyFont,
                  color: widget.page.primaryColor,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingM),

            // Description
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppTypography.bodyFont,
                  color: AppColors.gray600,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingL),
          ],
        ),
      ),
    );
  }
}

/// Page indicators for practice onboarding
class PracticeOnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;

  const PracticeOnboardingIndicators({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: AppConstants.animationNormal,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentPage ? activeColor : AppColors.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Custom button for practice onboarding
class PracticeOnboardingButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final Color? backgroundColor;

  const PracticeOnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.backgroundColor,
  });

  @override
  State<PracticeOnboardingButton> createState() =>
      _PracticeOnboardingButtonState();
}

class _PracticeOnboardingButtonState extends State<PracticeOnboardingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color:
                widget.isSecondary
                    ? AppColors.gray100
                    : widget.backgroundColor ?? AppColors.primary,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            boxShadow:
                widget.isSecondary
                    ? null
                    : [
                      BoxShadow(
                        color: (widget.backgroundColor ?? AppColors.primary)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 2,
                      ),
                    ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: AppTypography.bodyFont,
                color: widget.isSecondary ? AppColors.gray700 : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
