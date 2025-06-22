import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';

/// Halaman onboarding dengan latar SVG dan navigasi.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang
      body: Stack(
        children: [
          // Latar belakang SVG fullscreen
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/onboarding.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Tombol di bagian bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 90,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // Tombol "MASUK"
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF3ED),
                        side: const BorderSide(
                          color: Color(0xFFFFA726),
                          width: 2,
                        ),
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
          ),
        ],
      ),
    );
  }
}
