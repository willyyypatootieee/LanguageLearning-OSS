import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../router/router_exports.dart';
import '../widgets/welcome_action_button.dart';

/// Welcome screen that serves as an intermediate step between onboarding and authentication
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen SVG background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/welcome.svg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF87CEEB), // Sky blue
                        Color(0xFFB6E5FF), // Light blue
                        Color(0xFFE6F7FF), // Very light blue
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.menu_book,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          // Buttons positioned at the bottom
          Positioned(
            left: AppConstants.spacingL,
            right: AppConstants.spacingL,
            bottom:
                MediaQuery.of(context).padding.bottom + AppConstants.spacingXl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Action buttons
                WelcomeActionButton(
                  text: 'MULAI BELAJAR',
                  onPressed: () => context.goToRegister(),
                  isPrimary: true,
                ),

                const SizedBox(height: AppConstants.spacingM),

                WelcomeActionButton(
                  text: 'SAYA SUDAH MEMILIKI AKUN',
                  onPressed: () => context.goToLogin(),
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
