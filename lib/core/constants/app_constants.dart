import 'package:flutter/material.dart';

/// A class to hold app-wide constants.
class AppConstants {
  // Animation durations
  static const Duration defaultTransitionDuration = Duration(milliseconds: 220);

  // Sizes
  static const double navbarHeight = 64.0;
  static const double navbarIndicatorSize = 52.0;
  static const double navbarIconSize = 34.0;

  // Spacing
  static const EdgeInsets navbarPadding = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const double bottomNavbarMargin = 24.0;
}
