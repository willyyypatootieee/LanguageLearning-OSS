import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/core.dart';
import 'navbar_item.dart';
import 'navbar_indicator.dart';

/// Widget bottom navigation bar dengan ikon SVG dan efek sederhana.
class Navbar extends StatelessWidget {
  // Indeks tab yang sedang dipilih
  final int selectedIndex;
  // Callback saat tab ditekan
  final ValueChanged<int>? onTap;

  // Constructor
  const Navbar({super.key, this.selectedIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Define navigation items
    final navItems = [
      NavbarItem(
        svgPath: 'assets/navbar/home.svg',
        index: 0,
        selectedIndex: selectedIndex,
        onTap: onTap ?? (_) {},
      ),
      NavbarItem(
        svgPath: 'assets/navbar/book.svg',
        index: 1,
        selectedIndex: selectedIndex,
        onTap: onTap ?? (_) {},
      ),
      NavbarItem(
        svgPath: 'assets/navbar/leaderboard.svg',
        index: 2,
        selectedIndex: selectedIndex,
        onTap: onTap ?? (_) {},
      ),
      NavbarItem(
        svgPath: 'assets/navbar/mouth.svg',
        index: 3,
        selectedIndex: selectedIndex,
        onTap: onTap ?? (_) {},
      ),
      NavbarItem(
        svgPath: 'assets/navbar/profile.svg',
        index: 4,
        selectedIndex: selectedIndex,
        onTap: onTap ?? (_) {},
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: AppConstants.navbarPadding,
        child: Container(
          height: AppConstants.navbarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [AppTheme.defaultShadow],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / navItems.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Fluid Indicator
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic, // Smoother fluid effect
                    tween: Tween<double>(
                      // Calculate proper begin value based on previous position
                      begin:
                          (selectedIndex == 0)
                              ? 0
                              : selectedIndex - 1.toDouble(),
                      end: selectedIndex.toDouble(),
                    ),
                    builder: (context, value, child) {
                      return NavbarIndicator(
                        value: value,
                        itemWidth: itemWidth,
                      );
                    },
                  ),
                  // Navigation items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: navItems,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
