/// User profile model for BeLing app
class UserProfile {
  final String id;
  final String username;
  final String email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime createdAt;
  final int health;
  final int coins;
  final DateTime lastHeartRegen;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    required this.createdAt,
    required this.health,
    required this.coins,
    required this.lastHeartRegen,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      scoreEnglish: json['score_english'] as int? ?? 0,
      streakDay: json['streak_day'] as int? ?? 0,
      totalXp: json['total_xp'] as int? ?? 0,
      currentRank: json['current_rank'] as String? ?? 'Wood',
      createdAt: DateTime.parse(json['created_at'] as String),
      health: json['health'] as int? ?? 5,
      coins: json['coins'] as int? ?? 0,
      lastHeartRegen: DateTime.parse(json['last_heart_regen'] as String),
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
      'health': health,
      'coins': coins,
      'last_heart_regen': lastHeartRegen.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    int? scoreEnglish,
    int? streakDay,
    int? totalXp,
    String? currentRank,
    DateTime? createdAt,
    int? health,
    int? coins,
    DateTime? lastHeartRegen,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      scoreEnglish: scoreEnglish ?? this.scoreEnglish,
      streakDay: streakDay ?? this.streakDay,
      totalXp: totalXp ?? this.totalXp,
      currentRank: currentRank ?? this.currentRank,
      createdAt: createdAt ?? this.createdAt,
      health: health ?? this.health,
      coins: coins ?? this.coins,
      lastHeartRegen: lastHeartRegen ?? this.lastHeartRegen,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, username: $username, totalXp: $totalXp, health: $health, coins: $coins)';
  }
}
