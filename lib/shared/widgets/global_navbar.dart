import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_constants.dart';

/// Navigation item data model
class NavItem {
  final String svgPath;
  final String label;

  const NavItem({required this.svgPath, required this.label});
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
      NavItem(svgPath: 'assets/navbar/home.svg', label: 'Home'),
      NavItem(svgPath: 'assets/navbar/book.svg', label: 'Learn'),
      NavItem(svgPath: 'assets/navbar/mouth.svg', label: 'Practice'),
      NavItem(svgPath: 'assets/navbar/leaderboard.svg', label: 'Leaderboard'),
      NavItem(svgPath: 'assets/navbar/profile.svg', label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: isSelected ? 40 : 32,
                          height: isSelected ? 40 : 32,
                          padding: EdgeInsets.all(isSelected ? 8 : 6),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            item.svgPath,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.gray400,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: isSelected ? 13 : 11,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.gray400,
                            fontFamily: AppTypography.bodyFont,
                          ),
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
