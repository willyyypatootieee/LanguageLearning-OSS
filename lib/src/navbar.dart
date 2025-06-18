import 'package:flutter/material.dart';
import '../screen/profile.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  const Navbar({super.key, this.selectedIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color(0xFFFCB900);
    Color unselectedColor = const Color(0xFFB3D8FF);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home
            GestureDetector(
              onTap: () {
                if (selectedIndex != 0) {
                  onTap?.call(0);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 0
                          ? const Color(0xFFE6F1FF)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      selectedIndex == 0
                          ? Border.all(color: unselectedColor, width: 2)
                          : null,
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.home_rounded,
                  color: selectedIndex == 0 ? selectedColor : Colors.grey,
                  size: 32,
                ),
              ),
            ),
            // Chest
            Icon(Icons.deck, color: const Color(0xFFF4B400), size: 32),
            // Steps
            Icon(
              Icons.directions_walk_rounded,
              color: const Color(0xFF40C4FF),
              size: 32,
            ),
            // Trophy
            Icon(
              Icons.emoji_events_rounded,
              color: const Color(0xFFFFC107),
              size: 32,
            ),
            // Profile
            GestureDetector(
              onTap: () {
                if (selectedIndex != 4) {
                  onTap?.call(4);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 4
                          ? const Color(0xFFE6F1FF)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      selectedIndex == 4
                          ? Border.all(color: unselectedColor, width: 2)
                          : null,
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.person,
                  color:
                      selectedIndex == 4
                          ? const Color(0xFF40C4FF)
                          : Colors.grey,
                  size: 32,
                ),
              ),
            ),
            // More
            Icon(
              Icons.more_horiz_rounded,
              color: const Color(0xFFB39DDB),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
