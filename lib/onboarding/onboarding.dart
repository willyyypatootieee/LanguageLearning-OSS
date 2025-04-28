import 'package:flutter/material.dart';
import 'package:experimental/main/home/home.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

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
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Feather',
                color: const Color.fromARGB(255, 140, 140, 140),
              ),
              child: Text(
                'The free, fun, and effective way to learn a language',
              ),
            ),
            const SizedBox(height: 16),
            // "I ALREADY HAVE AN ACCOUNT" button (outlined)
            SizedBox(
              width: 320,
              height: 56,

              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF7ED321),
                  side: const BorderSide(color: Color(0xFF7ED321), width: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('GET STARTED', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 16),
            // "I ALREADY HAVE AN ACCOUNT" button (outlined)
            SizedBox(
              width: 320,
              height: 56,

              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                style: FilledButton.styleFrom(
                  foregroundColor: Color(0xFF7ED321),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF7ED321), width: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'I ALREADY HAVE AN ACCOUNT',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
