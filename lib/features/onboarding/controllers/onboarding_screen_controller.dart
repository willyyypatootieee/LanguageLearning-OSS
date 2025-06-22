import 'package:flutter/material.dart';
import '../../../features/home/home.dart';

/// Controller for the Onboarding screen
class OnboardingScreenController {
  /// Navigate to home screen
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}
