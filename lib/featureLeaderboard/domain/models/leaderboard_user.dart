/// Leaderboard user model for leaderboard display
class LeaderboardUser {
  final String id;
  final String username;
  final int totalPoint;
  final String currentRank;

  const LeaderboardUser({
    required this.id,
    required this.username,
    required this.totalPoint,
    required this.currentRank,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] as String,
      username: json['username'] as String,
      totalPoint: json['total_xp'] as int,
      currentRank: json['current_rank'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'total_xp': totalPoint,
      'current_rank': currentRank,
    };
  }
}
