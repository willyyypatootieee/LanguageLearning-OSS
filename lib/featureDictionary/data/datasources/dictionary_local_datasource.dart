import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for dictionary feature
class DictionaryLocalDataSource {
  static const String _recentSearchesKey = 'recent_dictionary_searches';
  static const String _lastUpdateTimeKey = 'dictionary_last_update_time';
  static const String _phoneticsDataKey = 'cached_phonetics_data';
  static const Duration _cacheValidDuration = Duration(
    days: 7,
  ); // Cache valid for 7 days
  static const int _maxRecentSearches =
      10; // Maximum number of recent searches to store

  /// Save a search to recent searches
  Future<void> addRecentSearch(String term) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> searches = await getRecentSearches();

      // Remove the term if it already exists to avoid duplicates
      searches.removeWhere((item) => item.toLowerCase() == term.toLowerCase());

      // Add the new term at the beginning
      searches.insert(0, term);

      // Trim the list if it exceeds max size
      if (searches.length > _maxRecentSearches) {
        searches.removeLast();
      }

      await prefs.setStringList(_recentSearchesKey, searches);
      print('DEBUG: Added "$term" to recent dictionary searches');
    } catch (e) {
      print('ERROR: Failed to add recent search: $e');
    }
  }

  /// Get recent searches
  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentSearchesKey) ?? [];
    } catch (e) {
      print('ERROR: Failed to get recent searches: $e');
      return [];
    }
  }

  /// Cache phonetics data
  Future<void> cachePhoneticData(Map<String, dynamic> phoneticData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(phoneticData);

      await prefs.setString(_phoneticsDataKey, jsonString);

      // Store the timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastUpdateTimeKey, timestamp);

      print('DEBUG: Cached phonetics data (${jsonString.length} characters)');
      print(
        'DEBUG: Cache timestamp updated: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}',
      );
    } catch (e) {
      print('ERROR: Failed to cache phonetics data: $e');
    }
  }

  /// Get cached phonetics data
  Future<Map<String, dynamic>?> getCachedPhoneticData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_phoneticsDataKey);

      if (jsonString == null) {
        print('DEBUG: No cached phonetics data found');
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(jsonString);
      print(
        'DEBUG: Retrieved cached phonetics data (${jsonString.length} characters)',
      );
      return data;
    } catch (e) {
      print('ERROR: Failed to get cached phonetics data: $e');
      return null;
    }
  }

  /// Check if cache is still valid
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateTime = prefs.getInt(_lastUpdateTimeKey);

      if (lastUpdateTime == null) {
        print('DEBUG: No phonetics cache timestamp found');
        return false;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - lastUpdateTime;
      final lastUpdateDateTime = DateTime.fromMillisecondsSinceEpoch(
        lastUpdateTime,
      );

      // Convert to days for better readability in logs
      final daysSinceUpdate = difference ~/ (1000 * 60 * 60 * 24);

      // Cache is valid if it's less than the defined duration
      final isValid = difference <= _cacheValidDuration.inMilliseconds;

      if (isValid) {
        print(
          'DEBUG: Dictionary cache is valid (last updated: $lastUpdateDateTime, $daysSinceUpdate days ago)',
        );
      } else {
        print(
          'DEBUG: Dictionary cache is expired (last updated: $lastUpdateDateTime, $daysSinceUpdate days ago)',
        );
      }

      return isValid;
    } catch (e) {
      print('ERROR: Error checking dictionary cache validity: $e');
      return false;
    }
  }

  /// Invalidate the cache (force refresh)
  Future<void> invalidateCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdateTimeKey);
      print('DEBUG: Dictionary cache invalidated');
    } catch (e) {
      print('ERROR: Failed to invalidate dictionary cache: $e');
    }
  }

  /// Clear all cached data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchesKey);
      await prefs.remove(_phoneticsDataKey);
      await prefs.remove(_lastUpdateTimeKey);
      print('DEBUG: All dictionary data cleared');
    } catch (e) {
      print('ERROR: Failed to clear dictionary data: $e');
    }
  }
}
