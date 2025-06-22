import 'package:flutter/material.dart';

/// Widget that displays overview statistics cards
class OverviewSection extends StatelessWidget {
  final String dayStreak;
  final String totalXP;
  final String currentLeague;
  final String languageScore;

  const OverviewSection({
    super.key,
    required this.dayStreak,
    required this.totalXP,
    required this.currentLeague,
    required this.languageScore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildOverviewCard(
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.grey,
                  size: 40,
                ),
                dayStreak,
                'Hari beruntun',
                Colors.grey.withOpacity(0.1),
              ),
              const SizedBox(width: 16),
              _buildOverviewCard(
                const Icon(Icons.bolt, color: Color(0xFFFCB900), size: 40),
                totalXP,
                'Total XP',
                const Color(0xFFFCB900).withOpacity(0.1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildOverviewCard(
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD700),
                  size: 40,
                ),
                currentLeague,
                'Liga saat ini',
                const Color(0xFFFFD700).withOpacity(0.1),
              ),
              const SizedBox(width: 16),
              _buildOverviewCard(
                Container(
                  width: 40,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(
                    child: Text(
                      'US',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                languageScore,
                'Skor Bahasa Inggris',
                Colors.red.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    Widget icon,
    String value,
    String label,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
