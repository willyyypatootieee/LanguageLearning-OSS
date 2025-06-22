import 'package:flutter/material.dart';

/// A utility class for handling navigation in the app.
class AppRouter {
  /// Navigate to a new screen with fade transition
  static void navigateWithFade(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: const Duration(milliseconds: 220),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
