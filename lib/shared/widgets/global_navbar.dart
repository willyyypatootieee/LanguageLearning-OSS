import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      NavItem(svgPath: 'assets/navbar/home.svg'), // 0
      NavItem(svgPath: 'assets/navbar/book.svg'), // 1
      NavItem(svgPath: 'assets/navbar/mouth.svg'), // 2
      NavItem(svgPath: 'assets/navbar/leaderboard.svg'), // 3
      NavItem(svgPath: 'assets/navbar/love.svg'), // 4
      NavItem(svgPath: 'assets/navbar/profile.svg'), // 5
    ];
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 56 : 48,
                      height: isSelected ? 56 : 48,
                      padding: EdgeInsets.all(isSelected ? 8 : 6),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color.fromARGB(
                                  255,
                                  218,
                                  98,
                                  30,
                                ).withValues(alpha: 0.15)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SvgPicture.asset(item.svgPath),
                    ),
                  ),
                ),
              );
            }).toList(),
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
