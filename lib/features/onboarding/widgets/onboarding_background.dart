import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Background widget for the onboarding screen
class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SvgPicture.asset(
        'assets/images/onboarding.svg',
        fit: BoxFit.cover,
      ),
    );
  }
}
