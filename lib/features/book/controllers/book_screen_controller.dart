import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../home/home.dart';
import '../../leaderboard/leaderboard.dart';
import '../../practice/practice.dart';
import '../../profile/profile.dart';

/// Controller for the Book screen
class BookScreenController {
  /// Handle navigation when navbar item is tapped
  static void handleNavbarTap(BuildContext context, int index) {
    if (index == 0) {
      AppRouter.navigateWithFade(context, const HomeScreen());
    } else if (index == 1) {
      // Already on Book screen
    } else if (index == 2) {
      AppRouter.navigateWithFade(context, const LeaderboardScreen());
    } else if (index == 3) {
      AppRouter.navigateWithFade(context, const PracticeScreen());
    } else if (index == 4) {
      AppRouter.navigateWithFade(context, const ProfileScreen());
    }
  }
}
