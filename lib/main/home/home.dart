import 'package:flutter/material.dart';
import 'package:experimental/src/navbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Feather',
              color: const Color.fromARGB(255, 140, 140, 140),
            ),
            child: Text('Welcome to the Home Screen!'),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
