import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/leaderboard_screen_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Leaderboard',
      selectedNavIndex: 2,
      onNavTap:
          (index) =>
              LeaderboardScreenController.handleNavbarTap(context, index),
      body: const Center(child: Text('Leaderboard Screen Content')),
    );
  }
}
