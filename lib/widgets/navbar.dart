import 'dart:ui';
import 'package:flutter/material.dart';

/// Widget bottom navigation bar dengan efek glassmorphism dan interaksi dinamis.
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
      _buildNavItem(Icons.home, 0, 'Home'),
      _buildNavItem(Icons.search, 1, 'Search'),
      _buildNavItem(Icons.add_circle_rounded, 2, 'Add'),
      _buildNavItem(Icons.notifications, 3, 'Notif'),
    ];
    final profileItem = _buildProfileNavItem(Icons.person, 4, 'Profile');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      32,
                    ), // More rounded corners
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 25,
                        sigmaY: 25,
                      ), // Stronger blur
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(35), // More transparent
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withAlpha(65),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final itemWidth =
                                constraints.maxWidth / navItems.length;
                            // Calculate indicator size and position to match icon
                            final indicatorSize =
                                48.0; // Slightly larger than icon
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Liquid indicator
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.elasticOut,
                                  left:
                                      selectedIndex < 4
                                          ? selectedIndex * itemWidth +
                                              (itemWidth - indicatorSize) / 2
                                          : 0,
                                  top:
                                      (64 - indicatorSize) /
                                      2, // Center vertically in container
                                  width: selectedIndex < 4 ? indicatorSize : 0,
                                  height: indicatorSize,
                                  child:
                                      selectedIndex < 4
                                          ? TweenAnimationBuilder<double>(
                                            tween: Tween(begin: 0.8, end: 1.0),
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeOutCubic,
                                            builder: (context, value, child) {
                                              return Transform.scale(
                                                scale: value,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withAlpha(75),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: selectedColor
                                                            .withAlpha(30),
                                                        blurRadius: 20,
                                                        spreadRadius: 2,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                          : const SizedBox.shrink(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: navItems,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            profileItem,
          ],
        ),
      ),
    );
  }

  // Helper to determine if background is light or dark for contrast
  Color _getReadableColor(BuildContext context, {bool isSelected = false}) {
    // Try to get the background color behind the navbar
    // If the background is light, use black; if dark, use white
    // For glassmorphism, we assume a light background if luminance > 0.5
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final isLight = bgColor.computeLuminance() > 0.5;
    return isSelected
        ? (isLight ? Colors.black : Colors.white)
        : (isLight ? Colors.black54 : Colors.white70);
  }

  // Widget untuk setiap item navbar (Home, Search, Add, Notif)
  Widget _buildNavItem(IconData icon, int index, String label) {
    return Builder(
      builder: (context) {
        final isSelected = selectedIndex == index;
        final readableColor = _getReadableColor(
          context,
          isSelected: isSelected,
        );
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap?.call(index),
            child: SizedBox(
              height: 52,
              child: Center(child: Icon(icon, size: 24, color: readableColor)),
            ),
          ),
        );
      },
    );
  }

  // Widget khusus untuk Profile (sendiri di lingkaran)
  Widget _buildProfileNavItem(IconData icon, int index, String label) {
    return Builder(
      builder: (context) {
        final isSelected = selectedIndex == index;
        final readableColor = _getReadableColor(
          context,
          isSelected: isSelected,
        );
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            width: 56,
            height: 64,
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withAlpha(90)
                      : Colors.white.withAlpha(46),
              shape: BoxShape.circle,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: selectedColor.withAlpha(46),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : [],
              border: Border.all(color: Colors.white.withAlpha(89), width: 1.5),
            ),
            child: Center(child: Icon(icon, size: 24, color: readableColor)),
          ),
        );
      },
    );
  }
}
