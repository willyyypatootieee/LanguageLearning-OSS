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
    // SafeArea agar tidak tertutup notch atau sistem UI
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 4,
            ), // tighter padding
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(46), // 0.18 * 255 ≈ 46
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(89), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Home
                _buildNavItem(Icons.home, 0, 'Home'),
                // Tombol Search
                _buildNavItem(Icons.search, 1, 'Search'),
                // Tombol Add
                _buildNavItem(Icons.add_circle_rounded, 2, 'Add'),
                // Tombol Notifications
                _buildNavItem(Icons.notifications, 3, 'Notif'),
                // Tombol Profile
                _buildNavItem(Icons.person, 4, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk setiap item navbar
  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap?.call(index), // Aksi saat item ditekan
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutExpo,
          padding: const EdgeInsets.symmetric(vertical: 4), // tighter
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Colors.white.withAlpha(71)
                    : Colors.transparent, // 0.28 * 255 ≈ 71
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: selectedColor.withAlpha(46), // 0.18 * 255 ≈ 46
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return isSelected
                      ? LinearGradient(
                        colors: [
                          selectedColor.withAlpha(230), // 0.9 * 255 ≈ 230
                          Colors.white.withAlpha(179), // 0.7 * 255 ≈ 179
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds)
                      : LinearGradient(
                        colors: [unselectedColor, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Icon(
                  icon,
                  size: isSelected ? 28 : 24, // smaller icon
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 2), // tighter spacing
              Text(
                label,
                style: TextStyle(
                  fontSize: 12, // smaller font
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? selectedColor : unselectedColor,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
