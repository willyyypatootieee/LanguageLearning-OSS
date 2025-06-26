/// Request model for updating profile user information
class UpdateProfileRequest {
  final String? username;
  final int? scoreEnglish;
  final int? streakDay;
  final int? totalXp;
  final String? currentRank;
  final String? riveState;

  const UpdateProfileRequest({
    this.username,
    this.scoreEnglish,
    this.streakDay,
    this.totalXp,
    this.currentRank,
    this.riveState,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (username != null) data['username'] = username;
    if (scoreEnglish != null) data['score_english'] = scoreEnglish;
    if (streakDay != null) data['streak_day'] = streakDay;
    if (totalXp != null) data['total_xp'] = totalXp;
    if (currentRank != null) data['current_rank'] = currentRank;
    if (riveState != null) data['rive_state'] = riveState;

    return data;
  }

  bool get isEmpty => toJson().isEmpty;

  UpdateProfileRequest copyWith({
    String? username,
    int? scoreEnglish,
    int? streakDay,
    int? totalXp,
    String? currentRank,
    String? riveState,
  }) {
    return UpdateProfileRequest(
      username: username ?? this.username,
      scoreEnglish: scoreEnglish ?? this.scoreEnglish,
      streakDay: streakDay ?? this.streakDay,
      totalXp: totalXp ?? this.totalXp,
      currentRank: currentRank ?? this.currentRank,
      riveState: riveState ?? this.riveState,
    );
  }
}
