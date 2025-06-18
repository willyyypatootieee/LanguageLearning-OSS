import 'dart:async';
import 'package:flutter/material.dart';
import 'package:experimental/onboarding/onboarding.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Mengarahkan ke Splash Screen aplikasi

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    });
  }

  @override
  Widget build(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Color(0xFFFE8B00),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo.svg
              // Membutuhkan package flutter_svg
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              // Menampilkan text.svg di bawah logo
              SvgPicture.asset(
                'assets/images/text.svg',
                width: 180,
                height: 60,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
