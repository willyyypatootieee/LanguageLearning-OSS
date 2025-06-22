import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'navbar/navbar.dart';

/// A base screen widget that includes the navbar and common layout
class BaseScreen extends StatelessWidget {
  final Widget body;
  final int selectedNavIndex;
  final Function(int) onNavTap;
  final String? title;
  final bool showAppBar;

  const BaseScreen({
    super.key,
    required this.body,
    required this.selectedNavIndex,
    required this.onNavTap,
    this.title,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text(title ?? '')) : null,
      body: Stack(
        children: [
          // Main content
          body,

          // Navbar at bottom
          Positioned(
            left: AppConstants.bottomNavbarMargin,
            right: AppConstants.bottomNavbarMargin,
            bottom: AppConstants.bottomNavbarMargin,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [AppTheme.largeShadow],
              ),
              child: Navbar(selectedIndex: selectedNavIndex, onTap: onNavTap),
            ),
          ),
        ],
      ),
    );
  }
}
