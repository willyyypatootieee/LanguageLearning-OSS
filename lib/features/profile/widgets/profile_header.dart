import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Widget that displays the profile header including avatar, name, and stats
class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String joinDate;
  final String courseCount;
  final String followingCount;
  final String followerCount;
  final bool hasFlag;
  final Function()? onAddFriendPressed;
  final Function()? onSettingsPressed;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.joinDate,
    required this.courseCount,
    required this.followingCount,
    required this.followerCount,
    this.hasFlag = false,
    this.onAddFriendPressed,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
      child: Column(
        children: [
          // Settings icon
          Row(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: onSettingsPressed,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Profile picture
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF235298),
              shape: BoxShape.circle,
            ),
            child: const ClipOval(
              child: RiveAnimation.asset(
                'assets/images/personalised_character.riv',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Username and join date
          Text(
            name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '$username • $joinDate',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Kursus', courseCount, hasFlag),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildStatItem('Mengikuti', followingCount),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildStatItem('Pengikut', followerCount),
            ],
          ),
          const SizedBox(height: 20),

          // Add friend button
          GestureDetector(
            onTap: onAddFriendPressed,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'TAMBAH TEMAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [bool hasFlag = false]) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasFlag)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.red,
                  ),
                  child: const Center(
                    child: Text(
                      'US',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
