import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../book/book.dart';
import '../../home/home.dart';
import '../../leaderboard/leaderboard.dart';
import '../../profile/profile.dart';

/// Controller for the Practice screen
class PracticeScreenController {
  /// Handle navigation when navbar item is tapped
  static void handleNavbarTap(BuildContext context, int index) {
    if (index == 0) {
      AppRouter.navigateWithFade(context, const HomeScreen());
    } else if (index == 1) {
      AppRouter.navigateWithFade(context, const BookScreen());
    } else if (index == 2) {
      AppRouter.navigateWithFade(context, const LeaderboardScreen());
    } else if (index == 3) {
      // Already on Practice screen
    } else if (index == 4) {
      AppRouter.navigateWithFade(context, const ProfileScreen());
    }
  }
}
