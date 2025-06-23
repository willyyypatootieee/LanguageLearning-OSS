import 'package:flutter/material.dart';

/// A class to hold app theme data.
class AppTheme {
  // Primary colors
  static const Color selectedColor = Color(0xFFFCB900);
  static const Color unselectedColor = Color(0xFFB3D8FF);

  // Shadow
  static BoxShadow defaultShadow = BoxShadow(
    color: Colors.black.withAlpha(20), // Approx 8% opacity
    blurRadius: 15,
    offset: const Offset(0, 3),
  );

  static BoxShadow largeShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 16,
    offset: const Offset(0, 8),
  );
}
