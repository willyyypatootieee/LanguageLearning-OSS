/// User model representing a user in the application
class User {
  final String id;
  final String username;
  final String email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  User copyWith({
    String? id,
    String? username,
    String? email,
    int? scoreEnglish,
    int? streakDay,
    int? totalXp,
    String? currentRank,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      scoreEnglish: scoreEnglish ?? this.scoreEnglish,
      streakDay: streakDay ?? this.streakDay,
      totalXp: totalXp ?? this.totalXp,
      currentRank: currentRank ?? this.currentRank,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.scoreEnglish == scoreEnglish &&
        other.streakDay == streakDay &&
        other.totalXp == totalXp &&
        other.currentRank == currentRank &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        scoreEnglish.hashCode ^
        streakDay.hashCode ^
        totalXp.hashCode ^
        currentRank.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, scoreEnglish: $scoreEnglish, streakDay: $streakDay, totalXp: $totalXp, currentRank: $currentRank, createdAt: $createdAt)';
  }
}
