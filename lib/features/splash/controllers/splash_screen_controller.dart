import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/onboarding/onboarding.dart';
import '../../../features/home/home.dart';
import '../../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../../features/auth/screens/login_screen.dart';

/// Controller for the Splash screen
class SplashScreenController {
  /// Navigate to appropriate screen after checking auth status
  static void navigateToOnboarding(BuildContext context) {
    // Capture the context in a local variable to use later
    final currentContext = context;

    Future.delayed(const Duration(seconds: 3), () async {
      // Cek status autentikasi
      // Check authentication status
      if (!currentContext.mounted) return;

      final authViewModel = Provider.of<AuthViewModel>(
        currentContext,
        listen: false,
      );
      final isLoggedIn = await authViewModel.isLoggedIn();

      // Periksa status mounted setelah operasi async
      // Check mounted status after async operation
      if (!currentContext.mounted) {
        return; // Jika sudah login, navigasi ke halaman beranda
      }
      // If already logged in, navigate to home screen
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(currentContext, HomeScreen.routeName);
        return;
      }

      // Jika belum login, periksa apakah ini pertama kali buka aplikasi
      // If not logged in, check if this is first time opening the app
      final bool isFirstTime = await _checkFirstTimeUser();

      // Periksa status mounted lagi setelah operasi async kedua
      // Check mounted status again after second async operation
      if (!currentContext.mounted) {
        return; // Navigasi berdasarkan status first time
      }
      // Navigate based on first time status
      if (isFirstTime) {
        // Jika pertama kali, tampilkan onboarding
        // If first time, show onboarding
        Navigator.pushReplacementNamed(
          currentContext,
          OnboardingScreen.routeName,
        );
      } else {
        // Jika bukan pertama kali, tampilkan halaman login
        // If not first time, show login screen
        Navigator.pushReplacementNamed(currentContext, LoginScreen.routeName);
      }
    });
  }

  // Fungsi untuk memeriksa apakah pengguna pertama kali menggunakan aplikasi
  // Function to check if user is using the app for the first time
  static Future<bool> _checkFirstTimeUser() async {
    // Implementasi pengecekan pengguna pertama kali
    // Untuk saat ini, kita asumsikan selalu pertama kali
    // Implementation of first-time user checking
    // For now, we assume it's always the first time
    return true;
  }
}
