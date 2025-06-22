import 'package:flutter/material.dart';

/// Theme-related constants specific to profile feature
class ProfileTheme {
  // Colors
  static const Color headerBackgroundColor = Color(0xFF4371BC);
  static const Color headerDarkBackgroundColor = Color(0xFF235298);
  static const Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Color(
    0xB3FFFFFF,
  ); // White with 70% opacity
  static const Color dividerColor = Color(0x4DFFFFFF); // White with 30% opacity
  static const Color badgeOrangeColor = Colors.orange;
  static const Color badgeBlueColor = Colors.blue;
  static const Color flagRedColor = Colors.red;
  static const Color xpYellowColor = Color(0xFFFCB900);
  static const Color leagueGoldColor = Color(0xFFFFD700);
  static const Color viewAllButtonColor = Color(0xFF4371BC);

  // Badge-specific colors
  static const Color inactiveBadgeColor = Color(
    0x4D9E9E9E,
  ); // Grey with 30% opacity
  static const Color celebrationBadgeColor = Colors.orange;
  static const Color starBadgeColor = Colors.blue;
  static const Color medalBadgeColor = Colors.green;
  static const Color trophyBadgeColor = Colors.amber;

  // Text Styles
  static const TextStyle headerNameStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle headerInfoStyle = TextStyle(
    fontSize: 16,
    color: secondaryTextColor,
  );

  static const TextStyle statValueStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle statLabelStyle = TextStyle(
    fontSize: 16,
    color: secondaryTextColor,
  );

  static const TextStyle addFriendButtonStyle = TextStyle(
    color: primaryTextColor,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle viewAllButtonStyle = TextStyle(
    color: viewAllButtonColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardValueStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle cardLabelStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
  );

  // Decoration
  static BoxDecoration roundedContainerDecoration({
    Color color = Colors.white,
  }) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(16));
  }

  static BoxDecoration topRoundedContainerDecoration({
    Color color = Colors.white,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    );
  }

  static BoxDecoration flagDecoration() {
    return BoxDecoration(
      color: flagRedColor,
      borderRadius: BorderRadius.circular(2),
    );
  }

  static BoxDecoration addFriendButtonDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.white70),
      borderRadius: BorderRadius.circular(16),
    );
  }

  static BoxDecoration profilePictureDecoration() {
    return const BoxDecoration(
      color: headerDarkBackgroundColor,
      shape: BoxShape.circle,
    );
  }
}
