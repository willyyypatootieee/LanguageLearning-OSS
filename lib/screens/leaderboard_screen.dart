import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import 'home_screen.dart';
import 'book_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Stack(
        children: [
          const Center(child: Text('Leaderboard Screen')),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Navbar(
              selectedIndex: 2,
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const BookScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 2) {
                  // Already on Leaderboard
                } else if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const PracticeScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else if (index == 4) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ProfileScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
