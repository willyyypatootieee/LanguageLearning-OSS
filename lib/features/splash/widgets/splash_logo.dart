import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo widget for the splash screen
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        SvgPicture.asset('assets/images/logo.svg', width: 200, height: 200),
        const SizedBox(height: 20),
        // App name
        SvgPicture.asset('assets/images/text.svg', width: 180, height: 60),
      ],
    );
  }
}
