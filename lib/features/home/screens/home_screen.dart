import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/home_screen_controller.dart';
import '../widgets/home_background.dart';
import '../widgets/home_button.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background
          const HomeBackground(),

          // Button
          HomeButton(
            onTap: () => HomeScreenController.handleButtonTap(context),
          ),

          // Navbar
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Navbar(
                selectedIndex: 0,
                onTap:
                    (index) =>
                        HomeScreenController.handleNavbarTap(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
