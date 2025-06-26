import '../../../featureAuthentication/domain/models/user.dart';

/// Profile user model with extended information
class ProfileUser {
  final String id;
  final String username;
  final String email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime createdAt;
  final String? birthDate;
  final String? riveState;

  const ProfileUser({
    required this.id,
    required this.username,
    required this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    required this.createdAt,
    this.birthDate,
    this.riveState,
  });

  /// Create ProfileUser from authenticated User
  factory ProfileUser.fromAuthUser(User user) {
    return ProfileUser(
      id: user.id,
      username: user.username,
      email: user.email,
      scoreEnglish: user.scoreEnglish,
      streakDay: user.streakDay,
      totalXp: user.totalXp,
      currentRank: user.currentRank,
      createdAt: user.createdAt,
      // Extended fields will be null initially
      birthDate: null,
      riveState: null,
    );
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      scoreEnglish: json['score_english'] as int,
      streakDay: json['streak_day'] as int,
      totalXp: json['total_xp'] as int,
      currentRank: json['current_rank'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      birthDate: json['birth_date'] as String?,
      riveState: json['rive_state'] as String?,
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
      if (birthDate != null) 'birth_date': birthDate,
      if (riveState != null) 'rive_state': riveState,
    };
  }

  ProfileUser copyWith({
    String? id,
    String? username,
    String? email,
    int? scoreEnglish,
    int? streakDay,
    int? totalXp,
    String? currentRank,
    DateTime? createdAt,
    String? birthDate,
    String? riveState,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      scoreEnglish: scoreEnglish ?? this.scoreEnglish,
      streakDay: streakDay ?? this.streakDay,
      totalXp: totalXp ?? this.totalXp,
      currentRank: currentRank ?? this.currentRank,
      createdAt: createdAt ?? this.createdAt,
      birthDate: birthDate ?? this.birthDate,
      riveState: riveState ?? this.riveState,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileUser &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.scoreEnglish == scoreEnglish &&
        other.streakDay == streakDay &&
        other.totalXp == totalXp &&
        other.currentRank == currentRank &&
        other.createdAt == createdAt &&
        other.birthDate == birthDate &&
        other.riveState == riveState;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      username,
      email,
      scoreEnglish,
      streakDay,
      totalXp,
      currentRank,
      createdAt,
      birthDate,
      riveState,
    );
  }

  @override
  String toString() {
    return 'ProfileUser(id: $id, username: $username, email: $email, scoreEnglish: $scoreEnglish, streakDay: $streakDay, totalXp: $totalXp, currentRank: $currentRank, createdAt: $createdAt, birthDate: $birthDate, riveState: $riveState)';
  }
}
