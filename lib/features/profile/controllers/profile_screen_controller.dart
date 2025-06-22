import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../book/book.dart';
import '../../home/home.dart';
import '../../leaderboard/leaderboard.dart';
import '../../practice/practice.dart';

/// Controller for the Profile screen
class ProfileScreenController {
  /// Handle navigation when navbar item is tapped
  static void handleNavbarTap(BuildContext context, int index) {
    if (index == 0) {
      AppRouter.navigateWithFade(context, const HomeScreen());
    } else if (index == 1) {
      AppRouter.navigateWithFade(context, const BookScreen());
    } else if (index == 2) {
      AppRouter.navigateWithFade(context, const LeaderboardScreen());
    } else if (index == 3) {
      AppRouter.navigateWithFade(context, const PracticeScreen());
    } else if (index == 4) {
      // Already on Profile screen
    }
  }
}
