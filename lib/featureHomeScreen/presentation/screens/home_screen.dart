import 'package:flutter/material.dart';
import '../../../router/router_exports.dart';
import '../../../shared/shared_exports.dart';

/// Main home screen of the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    switch (index) {
      case 0:
        appRouter.goToHome();
        break;
      case 1:
        appRouter.goToDictionary();
        break;
      case 2:
        // Navigate to practice section
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Practice feature coming soon!')),
        );
        break;
      case 3:
        appRouter.goToLeaderboard();
        break;
      case 4:
        appRouter.goToProfile();
        break;
    }
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Fullscreen background image
          Positioned.fill(
            child: Image.asset('assets/images/home.png', fit: BoxFit.cover),
          ),
        ],
      ),
      bottomNavigationBar: MainNavbar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
