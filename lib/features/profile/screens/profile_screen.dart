import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/profile_screen_controller.dart';
import '../models/models.dart';
import '../viewmodels/viewmodels.dart';
import '../widgets/widgets.dart';
import '../theme/theme.dart';
import '../constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    // Handle loading state
    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Handle error state
    if (viewModel.hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${viewModel.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.refreshProfile(),
                child: Text(ProfileStrings.retryButton),
              ),
            ],
          ),
        ),
      );
    }

    // Safe access to user profile
    final userProfile = viewModel.userProfile ?? UserProfile.mock();

    // Convert badge models to UI widgets
    final badgeWidgets =
        userProfile.badges.map((badge) {
          if (!badge.isEarned) {
            return BadgeItem(backgroundColor: ProfileTheme.inactiveBadgeColor);
          }

          switch (badge.type) {
            case BadgeType.celebration:
              return BadgeItem(
                icon: Icons.celebration,
                backgroundColor: ProfileTheme.celebrationBadgeColor,
              );
            case BadgeType.star:
              return BadgeItem(
                icon: Icons.star,
                backgroundColor: ProfileTheme.starBadgeColor,
              );
            case BadgeType.medal:
              return BadgeItem(
                icon: Icons.military_tech,
                backgroundColor: ProfileTheme.medalBadgeColor,
              );
            case BadgeType.trophy:
              return BadgeItem(
                icon: Icons.emoji_events,
                backgroundColor: ProfileTheme.trophyBadgeColor,
              );
            case BadgeType.unknown:
              return BadgeItem(
                backgroundColor: ProfileTheme.inactiveBadgeColor,
              );
          }
        }).toList();

    return BaseScreen(
      showAppBar: false,
      selectedNavIndex: 4,
      onNavTap:
          (index) => ProfileScreenController.handleNavbarTap(context, index),
      body: SingleChildScrollView(
        child: Container(
          color: ProfileTheme.headerBackgroundColor,
          child: Column(
            children: [
              // Top profile section
              ProfileHeader(
                name: viewModel.displayName,
                username: viewModel.displayUsername,
                joinDate: viewModel.displayJoinDate,
                courseCount: viewModel.displayCourseCount,
                followingCount: viewModel.displayFollowingCount,
                followerCount: viewModel.displayFollowerCount,
                hasFlag:
                    viewModel.showLanguageFlag &&
                    viewModel.displayLanguageCode == 'US',
                onAddFriendPressed: () => viewModel.addFriend(),
                onSettingsPressed: () {
                  // Settings logic will be implemented later
                },
              ),

              // Stats and badges section with white background
              Container(
                decoration: ProfileTheme.topRoundedContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverviewSection(
                      dayStreak: viewModel.displayDayStreak,
                      totalXP: viewModel.displayTotalXP,
                      currentLeague: viewModel.displayCurrentLeague,
                      languageScore: viewModel.displayLanguageScore,
                    ),
                    BadgesSection(
                      badges: badgeWidgets,
                      onViewAllPressed: () {
                        // View all badges logic will be implemented later
                      },
                    ),
                    const SizedBox(height: 100), // Extra space for the navbar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
