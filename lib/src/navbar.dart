import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Home (selected)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE6F1FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB3D8FF), width: 2),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.home_rounded,
                color: const Color(0xFFFCB900),
                size: 32,
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
            // Bird (Duolingo mascot, use a placeholder icon)
            Icon(
              Icons.sports_martial_arts, // Placeholder for mascot
              color: const Color(0xFF40C4FF),
              size: 32,
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
