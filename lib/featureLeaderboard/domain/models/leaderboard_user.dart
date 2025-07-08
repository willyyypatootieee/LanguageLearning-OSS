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
    // Handle potentially missing fields
    final totalXpValue = json['total_xp'];
    int totalPoint = 0;

    if (totalXpValue is int) {
      totalPoint = totalXpValue;
    } else if (totalXpValue is String) {
      try {
        totalPoint = int.parse(totalXpValue);
      } catch (e) {
        print('Error parsing total_xp: $e');
      }
    }

    return LeaderboardUser(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? 'Unknown User',
      totalPoint: totalPoint,
      currentRank: json['current_rank'] as String? ?? 'Unranked',
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
