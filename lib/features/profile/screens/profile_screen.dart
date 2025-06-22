import 'package:flutter/material.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/profile_screen_controller.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> _profileFuture;
  
  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileScreenController.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final userProfile = snapshot.data ?? UserProfile.mock();        // Convert badge models to UI widgets
        final badgeWidgets = userProfile.badges.map((badge) {
          if (!badge.isEarned) {
            return BadgeItem(backgroundColor: Colors.grey.withOpacity(0.3));
          }
          
          switch (badge.type) {
            case BadgeType.celebration:
              return const BadgeItem(
                icon: Icons.celebration,
                backgroundColor: Colors.orange,
              );
            case BadgeType.star:
              return const BadgeItem(
                icon: Icons.star,
                backgroundColor: Colors.blue,
              );
            case BadgeType.medal:
              return const BadgeItem(
                icon: Icons.military_tech,
                backgroundColor: Colors.green,
              );
            case BadgeType.trophy:
              return const BadgeItem(
                icon: Icons.emoji_events,
                backgroundColor: Colors.amber,
              );
            case BadgeType.unknown:
              return BadgeItem(backgroundColor: Colors.grey.withOpacity(0.3));
          }
        }).toList();
      return BaseScreen(
      showAppBar: false,
      selectedNavIndex: 4,
      onNavTap:
          (index) => ProfileScreenController.handleNavbarTap(context, index),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF4371BC), // Blue background for top section
          child: Column(
            children: [
              // Top profile section
              ProfileHeader(
                name: userProfile.name,
                username: userProfile.username,
                joinDate: userProfile.joinDate,
                courseCount: userProfile.courseCount,
                followingCount: userProfile.followingCount,
                followerCount: userProfile.followerCount,
                hasFlag: userProfile.languageCode == 'US',
                onAddFriendPressed: () {
                  // Add friend logic
                },
                onSettingsPressed: () {
                  // Settings logic
                },
              ),

              // Stats and badges section with white background
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverviewSection(
                      dayStreak: userProfile.dayStreak,
                      totalXP: userProfile.totalXP,
                      currentLeague: userProfile.currentLeague,
                      languageScore: userProfile.languageScore,
                    ),
                    BadgesSection(
                      badges: badgeWidgets,
                      onViewAllPressed: () {
                        // View all badges logic
                      },
                    ),
                    const SizedBox(height: 100), // Extra space for the navbar
                  ],
                ),              ),
            ],
          ),
        ),
      ),
    );
      }
    );
  }
}
