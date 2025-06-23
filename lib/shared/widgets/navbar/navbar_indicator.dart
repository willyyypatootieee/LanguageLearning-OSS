import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Animated circle indicator that moves with navbar selection.
class NavbarIndicator extends StatelessWidget {
  final double value;
  final double itemWidth;

  const NavbarIndicator({
    super.key,
    required this.value,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:
          value * itemWidth +
          (itemWidth - AppConstants.navbarIndicatorSize) / 2,
      top: (AppConstants.navbarHeight - AppConstants.navbarIndicatorSize) / 2,
      child: Container(
        width: AppConstants.navbarIndicatorSize,
        height: AppConstants.navbarIndicatorSize,
        decoration: BoxDecoration(
          color: AppTheme.selectedColor.withAlpha(38), // Approx 15% opacity
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
