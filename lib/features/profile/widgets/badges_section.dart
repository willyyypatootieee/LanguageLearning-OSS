import 'package:flutter/material.dart';

/// Widget that displays the monthly badges section
class BadgesSection extends StatelessWidget {
  final List<BadgeItem> badges;
  final Function()? onViewAllPressed;

  const BadgesSection({super.key, required this.badges, this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lencana Bulanan',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text(
                  'LIHAT SEMUA',
                  style: TextStyle(
                    color: Color(0xFF4371BC),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(26), // Approx 10% opacity
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: badges.map((badge) => badge).toList(),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

/// Widget representing an individual badge item
class BadgeItem extends StatelessWidget {
  final IconData? icon;
  final Color backgroundColor;

  const BadgeItem({super.key, this.icon, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child:
          icon != null
              ? Icon(icon, color: Colors.white, size: 30)
              : const SizedBox(),
    );
  }
}
