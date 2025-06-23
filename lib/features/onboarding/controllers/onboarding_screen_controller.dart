import 'package:flutter/material.dart';
import '../../../features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for the Onboarding screen
class OnboardingScreenController {
  /// Navigate to login screen and mark onboarding as completed
  static void navigateToHome(BuildContext context) async {
    // Simpan status bahwa onboarding sudah selesai
    // Save status that onboarding is completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'onboarding_completed',
      true,
    ); // Navigasi ke halaman login
    // Navigate to login screen
    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
