import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _HomeState();
}

class _HomeState extends State<Onboarding> {
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
                'assets/images/onboarding.png',
                width: 400,
                height: 400,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
