import 'package:flutter/material.dart';
import '../controllers/onboarding_screen_controller.dart';

/// Button widget for onboarding screen actions
class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 90,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            // Sign in button
            Expanded(
              child: OutlinedButton(
                onPressed:
                    () => OnboardingScreenController.navigateToHome(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF3ED),
                  side: const BorderSide(color: Color(0xFFFFA726), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'MASUK',
                  style: TextStyle(color: Color(0xFFFFA726)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
