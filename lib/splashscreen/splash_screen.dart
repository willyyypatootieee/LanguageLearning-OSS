import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Pointing to App Splash Screen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(
                'assets/images/splashscreen.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
