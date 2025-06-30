import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import '../../core/constants/app_constants.dart';

/// Navigation item data model
class NavItem {
  final String svgPath;

  const NavItem({required this.svgPath});
}

/// Global floating navigation bar component
/// Used across all screens that need bottom navigation
class GlobalNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const GlobalNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const navItems = [
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.book, title: 'Dictionary'),
      TabItem(icon: Icons.mic, title: 'Practice'),
      TabItem(icon: Icons.leaderboard, title: 'Leaderboard'),
      TabItem(icon: Icons.person, title: 'Profile'),
    ];
    return BottomBarDefault(
      items: navItems,
      backgroundColor: Colors.white,
      color: AppColors.gray300,
      colorSelected: AppColors.primary,
      indexSelected: selectedIndex,
      onTap: onTap,
      animated: true,
      iconSize: 28,
    );
  }
}

/// Pre-configured navbar for the main app navigation
class MainNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalNavbar(selectedIndex: currentIndex, onTap: onTap);
  }
}
