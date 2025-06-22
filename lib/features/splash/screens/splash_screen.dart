import 'package:flutter/material.dart';
import '../controllers/splash_screen_controller.dart';
import '../widgets/splash_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding after delay
    SplashScreenController.navigateToOnboarding(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFE8B00),
      body: const Center(child: SplashLogo()),
    );
  }
}
