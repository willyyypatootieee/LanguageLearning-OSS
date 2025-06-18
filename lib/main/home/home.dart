import 'package:flutter/material.dart';
import 'package:experimental/src/navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screen/profile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fullscreen SVG background
          Positioned.fill(
            child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
          ),
          // PNG button at the same position and scale
          Positioned(
            top: 40, // Adjust this value to match the checkmark position
            left: MediaQuery.of(context).size.width * 0.62, // Adjust as needed
            child: GestureDetector(
              onTap: () {
                // TODO: Add your action here
              },
              child: Image.asset(
                'assets/images/button.png',
                width: 64,
                height: 64,
              ),
            ),
          ),
          // Buttons at the bottom, above the SVG
          Positioned(
            left: 0,
            right: 0,
            bottom: 90, // Move buttons higher
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                children: [
                  // ...add your buttons here...
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 4) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfileScreen(),
                settings: const RouteSettings(name: '/profile'),
                transitionDuration: const Duration(milliseconds: 220),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
