import 'package:flutter/material.dart';

// Pointing to App Splash Screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashscreen.png',
            ), // Replace with your image path
            const SizedBox(height: 20),
            const Text(
              'Duolingo Clone',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
