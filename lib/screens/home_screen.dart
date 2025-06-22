import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import 'book_screen.dart';
import 'leaderboard_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';

/// Halaman utama dengan latar belakang dan tombol di posisi tertentu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Stack(
        children: [
          const Center(child: Text('Home Screen')),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Navbar(
              selectedIndex: 0,
              onTap: (index) {
                if (index == 0) {
                  // Already on Home
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
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LeaderboardScreen(),
                      transitionDuration: const Duration(milliseconds: 220),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
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
