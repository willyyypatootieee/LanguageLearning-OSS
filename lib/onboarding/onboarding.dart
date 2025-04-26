import 'package:flutter/material.dart';
import 'package:experimental/splashscreen/splash_screen.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color to white
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/onboarding.png',
              width: 400,
              height: 400,
            ),
            Text(
              'The free, fun, and effective way to learn a language',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: SplashScreen,
            style: FilledButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
            // onPressed: () => Navigator.of(context).pushNamed('/questions'),
            icon: const Icon(Icons.stars),
            label: const Text(
              'Start Quiz!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
