import 'package:flutter/material.dart';
import '../../../features/onboarding/onboarding.dart';

/// Controller for the Splash screen
class SplashScreenController {
  /// Navigate to onboarding screen after delay
  static void navigateToOnboarding(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      ),
    );
  }
}
