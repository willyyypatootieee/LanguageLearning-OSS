import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:experimental/main/home/home.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fullscreen SVG background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/onboarding.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Buttons at the bottom, above the SVG
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // <-- Move buttons higher (was 40)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // "MASUK" button (outlined, white bg)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
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
                        style: TextStyle(
                          color: Color(0xFFFFA726),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // "DAFTAR AKUN" button (filled, orange bg)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement register navigation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA726),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'DAFTAR AKUN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
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
