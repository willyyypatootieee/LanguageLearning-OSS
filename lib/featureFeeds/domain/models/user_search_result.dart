/// User search result model
class UserSearchResult {
  final String id;
  final String username;
  final String email;
  final int totalXp;
  final int streakDay;
  final String currentRank;
  final bool isFriend;
  final bool hasPendingRequest;

  const UserSearchResult({
    required this.id,
    required this.username,
    required this.email,
    required this.totalXp,
    required this.streakDay,
    required this.currentRank,
    required this.isFriend,
    required this.hasPendingRequest,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      totalXp: json['total_xp'] as int,
      streakDay: json['streak_day'] as int,
      currentRank: json['current_rank'] as String,
      isFriend: json['is_friend'] as bool? ?? false,
      hasPendingRequest: json['has_pending_request'] as bool? ?? false,
    );
  }
}
