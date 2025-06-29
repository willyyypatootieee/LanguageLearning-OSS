/// Leaderboard user model for leaderboard display
class LeaderboardUser {
  final String id;
  final String username;
  final int scoreEnglish;
  final String currentRank;

  const LeaderboardUser({
    required this.id,
    required this.username,
    required this.scoreEnglish,
    required this.currentRank,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] as String,
      username: json['username'] as String,
      scoreEnglish: json['score_english'] as int,
      currentRank: json['current_rank'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'score_english': scoreEnglish,
      'current_rank': currentRank,
    };
  }
}
