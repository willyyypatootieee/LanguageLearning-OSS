import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../domain/models/post.dart';

/// Local data source for posts data
class PostLocalDataSource {
  final AuthLocalDataSource _authDataSource;
  static const String _postsKey = 'cached_posts';
  static const String _lastUpdateTimeKey = 'posts_last_update_time';
  static const Duration _cacheValidDuration = Duration(
    minutes: 15,
  ); // Cache valid for 15 minutes

  PostLocalDataSource({AuthLocalDataSource? authDataSource})
    : _authDataSource = authDataSource ?? AuthLocalDataSource();

  /// Get cached user token
  Future<String?> getToken() async {
    return _authDataSource.getToken();
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    final user = await _authDataSource.getCurrentUser();
    return user?.id;
  }

  /// Cache posts to local storage
  Future<void> cachePosts(List<Post> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Store the posts
      final jsonData = posts.map((post) => post.toJson()).toList();
      final jsonString = jsonEncode(jsonData);

      // Add additional logging
      print('DEBUG: Caching ${posts.length} posts to local storage');
      print('DEBUG: Cache JSON size: ${jsonString.length} characters');

      // Store in shared preferences
      await prefs.setString(_postsKey, jsonString);

      // Store the timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastUpdateTimeKey, timestamp);

      print(
        'DEBUG: Posts cache timestamp updated: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}',
      );
    } catch (e) {
      print('ERROR: Failed to cache posts: $e');
    }
  }

  /// Get cached posts from local storage
  Future<List<Post>?> getCachedPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_postsKey);

      if (jsonString == null) {
        print('DEBUG: No cached posts found');
        return null;
      }

      print('DEBUG: Found cached posts data (${jsonString.length} characters)');

      final List<dynamic> jsonData = jsonDecode(jsonString);
      final posts = jsonData.map((json) => Post.fromJson(json)).toList();

      print('DEBUG: Successfully loaded ${posts.length} posts from cache');
      return posts;
    } catch (e) {
      // If parsing fails, return null to fetch fresh data
      print('ERROR: Failed to parse cached posts: $e');
      // Invalidate the cache since it's corrupted
      await invalidateCache();
      return null;
    }
  }

  /// Check if cache is still valid
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateTime = prefs.getInt(_lastUpdateTimeKey);

      if (lastUpdateTime == null) {
        print('DEBUG: No cache timestamp found');
        return false;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - lastUpdateTime;
      final lastUpdateDateTime = DateTime.fromMillisecondsSinceEpoch(
        lastUpdateTime,
      );

      // Convert to minutes for better readability in logs
      final minutesSinceUpdate = difference ~/ 60000;

      // Cache is valid if it's less than the defined duration
      final isValid = difference <= _cacheValidDuration.inMilliseconds;

      if (isValid) {
        print(
          'DEBUG: Cache is valid (last updated: $lastUpdateDateTime, ${minutesSinceUpdate}m ago)',
        );
      } else {
        print(
          'DEBUG: Cache is expired (last updated: $lastUpdateDateTime, ${minutesSinceUpdate}m ago)',
        );
      }

      return isValid;
    } catch (e) {
      print('ERROR: Error checking cache validity: $e');
      return false;
    }
  }

  /// Invalidate the cache (force refresh)
  Future<void> invalidateCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastUpdateTimeKey);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove(_postsKey);
    await prefs.remove(_lastUpdateTimeKey);
  }
}
