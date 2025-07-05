/// Friend model representing a user's friend
class Friend {
  final String id;
  final String username;
  final String email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime createdAt;

  const Friend({
    required this.id,
    required this.username,
    required this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    required this.createdAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      scoreEnglish: json['score_english'] as int,
      streakDay: json['streak_day'] as int,
      totalXp: json['total_xp'] as int,
      currentRank: json['current_rank'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'score_english': scoreEnglish,
      'streak_day': streakDay,
      'total_xp': totalXp,
      'current_rank': currentRank,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
