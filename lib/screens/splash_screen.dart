import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'onboarding_screen.dart';

/// Halaman splash screen yang akan berpindah ke onboarding setelah beberapa detik.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk pindah ke halaman onboarding setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFE8B00), // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo aplikasi
            SvgPicture.asset('assets/images/logo.svg', width: 200, height: 200),
            const SizedBox(height: 20),
            // Teks judul aplikasi
            SvgPicture.asset('assets/images/text.svg', width: 180, height: 60),
          ],
        ),
      ),
    );
  }
}
