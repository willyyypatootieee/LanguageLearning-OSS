/// Represents a user profile with all relevant information
class UserProfile {
  final String name;
  final String username;
  final String joinDate;
  final String courseCount;
  final String followingCount;
  final String followerCount;
  final String dayStreak;
  final String totalXP;
  final String currentLeague;
  final String languageScore;
  final String languageCode; // e.g., 'US' for English (US)
  final List<BadgeInfo> badges;

  const UserProfile({
    required this.name,
    required this.username,
    required this.joinDate,
    required this.courseCount,
    required this.followingCount,
    required this.followerCount,
    required this.dayStreak,
    required this.totalXP,
    required this.currentLeague,
    required this.languageScore,
    required this.languageCode,
    required this.badges,
  });

  /// Create a mock user profile for testing or preview purposes
  factory UserProfile.mock() {
    return UserProfile(
      name: 'Willy',
      username: '@supremaczy',
      joinDate: 'Bergabung Mei 2022',
      courseCount: '10+',
      followingCount: '84',
      followerCount: '41',
      dayStreak: '0',
      totalXP: '17298',
      currentLeague: 'Emas',
      languageScore: '104',
      languageCode: 'US',
      badges: [
        BadgeInfo(type: BadgeType.celebration, isEarned: true),
        BadgeInfo(type: BadgeType.star, isEarned: true),
        BadgeInfo(type: BadgeType.unknown, isEarned: false),
        BadgeInfo(type: BadgeType.unknown, isEarned: false),
      ],
    );
  }
}

/// Represents information about a badge in the user's profile
class BadgeInfo {
  final BadgeType type;
  final bool isEarned;

  const BadgeInfo({
    required this.type,
    required this.isEarned,
  });
}

/// Types of badges available in the application
enum BadgeType {
  celebration,
  star,
  medal,
  trophy,
  unknown,
}
