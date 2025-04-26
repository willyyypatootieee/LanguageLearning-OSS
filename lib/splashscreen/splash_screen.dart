import 'dart:async';
import 'package:flutter/material.dart';
import 'package:experimental/onboarding/onboarding.dart';

// Pointing to App Splash Screen

class SplashScreen extends StatefulWidget {
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
        backgroundColor: Color.fromARGB(255, 137, 223, 0),
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
