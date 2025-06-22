import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget bottom navigation bar dengan ikon SVG dan efek sederhana.
class Navbar extends StatelessWidget {
  // Warna untuk ikon yang dipilih
  static const Color selectedColor = Color(0xFFFCB900);
  // Warna untuk ikon yang tidak dipilih
  static const Color unselectedColor = Color(0xFFB3D8FF);

  // Indeks tab yang sedang dipilih
  final int selectedIndex;
  // Callback saat tab ditekan
  final ValueChanged<int>? onTap;
  // Konstruktor Navbar
  const Navbar({super.key, this.selectedIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _buildNavItem('assets/navbar/home.svg', 0),
      _buildNavItem('assets/navbar/book.svg', 1),
      _buildNavItem('assets/navbar/leaderboard.svg', 2),
      _buildNavItem('assets/navbar/mouth.svg', 3),
      _buildNavItem('assets/navbar/profile.svg', 4),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / navItems.length;
              final indicatorSize = 52.0; // Larger indicator
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
                      return Positioned(
                        left:
                            value * itemWidth + (itemWidth - indicatorSize) / 2,
                        top: (64 - indicatorSize) / 2,
                        child: Container(
                          width: indicatorSize,
                          height: indicatorSize,
                          decoration: BoxDecoration(
                            color: selectedColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
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

  // Widget untuk setiap item navbar menggunakan ikon SVG
  Widget _buildNavItem(String svgPath, int index) {
    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 34, // Much bigger icon size
            height: 34, // Much bigger icon size
          ),
        ),
      ),
    );
  }
}
