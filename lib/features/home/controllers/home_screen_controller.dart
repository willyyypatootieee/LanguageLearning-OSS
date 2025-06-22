import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../book/book.dart';
import '../../leaderboard/leaderboard.dart';
import '../../practice/practice.dart';
import '../../profile/profile.dart';

/// Controller for the Home screen
class HomeScreenController {
  /// Handle button tap on the home screen
  static void handleButtonTap(BuildContext context) {
    // Implement button action here
  }

  /// Handle navigation when navbar item is tapped
  static void handleNavbarTap(BuildContext context, int index) {
    if (index == 0) {
      // Already on Home screen
    } else if (index == 1) {
      AppRouter.navigateWithFade(context, const BookScreen());
    } else if (index == 2) {
      AppRouter.navigateWithFade(context, const LeaderboardScreen());
    } else if (index == 3) {
      AppRouter.navigateWithFade(context, const PracticeScreen());
    } else if (index == 4) {
      AppRouter.navigateWithFade(context, const ProfileScreenFactory());
    }
  }
}
