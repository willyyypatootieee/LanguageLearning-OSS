import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_constants.dart';

/// Navigation item data model
class NavItem {
  final String svgPath;
  final String title;

  const NavItem({required this.svgPath, required this.title});
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

  // Define nav items with SVG paths
  static const List<NavItem> _navItems = [
    NavItem(svgPath: 'assets/navbar/home.svg', title: 'Home'),
    NavItem(svgPath: 'assets/navbar/book.svg', title: 'Dictionary'),
    NavItem(svgPath: 'assets/navbar/mouth.svg', title: 'Practice'),
    NavItem(svgPath: 'assets/navbar/leaderboard.svg', title: 'Leaderboard'),
    NavItem(svgPath: 'assets/navbar/profile.svg', title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == selectedIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    child: Container(
                      padding: const EdgeInsets.all(AppConstants.spacingS),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.secondary.withValues(alpha: 0.3)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: SvgPicture.asset(
                        item.svgPath,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
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
