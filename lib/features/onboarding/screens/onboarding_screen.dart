import 'package:flutter/material.dart';
import '../widgets/onboarding_background.dart';
import '../widgets/onboarding_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: const [
          // Background SVG
          OnboardingBackground(),
          // Button
          OnboardingButton(),
        ],
      ),
    );
  }
}
