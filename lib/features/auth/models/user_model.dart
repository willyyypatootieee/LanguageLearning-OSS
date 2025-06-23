// User model
class UserModel {
  final String id;
  final String username;
  final String email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    required this.createdAt,
  });

  // Membuat model dari JSON
  // Creates a model from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      scoreEnglish: json['score_english'] ?? 0,
      streakDay: json['streak_day'] ?? 0,
      totalXp: json['total_xp'] ?? 0,
      currentRank: json['current_rank'] ?? 'Beginner',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
    );
  }

  // Konversi model ke JSON
  // Convert model to JSON
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
