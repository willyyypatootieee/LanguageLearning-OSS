/// Model for post reactions
class Reaction {
  final String id;
  final String postId;
  final String userId;
  final String emotion;
  final DateTime createdAt;
  final ReactionUser user;

  const Reaction({
    required this.id,
    required this.postId,
    required this.userId,
    required this.emotion,
    required this.createdAt,
    required this.user,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      emotion: json['emotion'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: ReactionUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'emotion': emotion,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }
}

/// Model for reaction user
class ReactionUser {
  final String id;
  final String username;
  final String? email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime? createdAt;

  const ReactionUser({
    required this.id,
    required this.username,
    this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    this.createdAt,
  });

  factory ReactionUser.fromJson(Map<String, dynamic> json) {
    return ReactionUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      scoreEnglish: json['score_english'] as int? ?? 0,
      streakDay: json['streak_day'] as int? ?? 0,
      totalXp: json['total_xp'] as int? ?? 0,
      currentRank: json['current_rank'] as String? ?? 'Wood',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      'score_english': scoreEnglish,
      'streak_day': streakDay,
      'total_xp': totalXp,
      'current_rank': currentRank,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
