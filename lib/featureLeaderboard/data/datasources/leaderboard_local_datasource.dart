import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/leaderboard_user.dart';

class LeaderboardLocalDataSource {
  static const String _usersKey = 'cached_leaderboard_users';
  static const String _lastUpdateTimeKey = 'leaderboard_last_update_time';
  static const Duration _cacheValidDuration = Duration(
    minutes: 15,
  ); // Cache valid for 15 minutes

  /// Cache leaderboard users to local storage
  Future<void> cacheLeaderboardUsers(List<LeaderboardUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    // Store the users
    final jsonData = users.map((user) => user.toJson()).toList();
    await prefs.setString(_usersKey, jsonEncode(jsonData));

    // Store the timestamp
    await prefs.setInt(
      _lastUpdateTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get cached leaderboard users from local storage
  Future<List<LeaderboardUser>?> getCachedLeaderboardUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);

    if (jsonString == null) {
      return null;
    }

    try {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((json) => LeaderboardUser.fromJson(json)).toList();
    } catch (e) {
      // If parsing fails, return null to fetch fresh data
      print('Error parsing cached leaderboard users: $e');
      return null;
    }
  }

  /// Check if cache is still valid
  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateTime = prefs.getInt(_lastUpdateTimeKey);

    if (lastUpdateTime == null) {
      return false;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final difference = currentTime - lastUpdateTime;

    // Cache is valid if it's less than the defined duration
    return difference <= _cacheValidDuration.inMilliseconds;
  }

  /// Invalidate the cache (force refresh)
  Future<void> invalidateCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastUpdateTimeKey);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
    await prefs.remove(_lastUpdateTimeKey);
  }
}
