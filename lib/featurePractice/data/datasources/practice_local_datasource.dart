import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for practice feature
class PracticeLocalDataSource {
  static const String _practiceOnboardingKey = 'practice_onboarding_completed';
  static const String _practiceStreakKey = 'practice_streak';
  static const String _totalPracticeTimeKey = 'total_practice_time';
  static const String _lastPracticeSessionKey = 'last_practice_session';
  static const String _practiceHistoryKey = 'practice_history';
  static const String _lastUpdateTimeKey = 'practice_last_update_time';
  static const String _aiResponseCacheKey = 'practice_ai_responses';
  static const Duration _cacheValidDuration = Duration(
    hours: 24,
  ); // Cache valid for 24 hours

  /// Check if practice onboarding has been completed
  Future<bool> isPracticeOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_practiceOnboardingKey) ?? false;
    } catch (e) {
      print('ERROR: Failed to check practice onboarding status: $e');
      return false;
    }
  }

  /// Mark practice onboarding as completed
  Future<void> completePracticeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_practiceOnboardingKey, true);
      print('DEBUG: Practice onboarding marked as completed');
    } catch (e) {
      print('ERROR: Failed to complete practice onboarding: $e');
    }
  }

  /// Get current practice streak
  Future<int> getPracticeStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_practiceStreakKey) ?? 0;
    } catch (e) {
      print('ERROR: Failed to get practice streak: $e');
      return 0;
    }
  }

  /// Set practice streak
  Future<void> setPracticeStreak(int streak) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_practiceStreakKey, streak);
      print('DEBUG: Practice streak updated to $streak');
    } catch (e) {
      print('ERROR: Failed to set practice streak: $e');
    }
  }

  /// Get total practice time in minutes
  Future<int> getTotalPracticeTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_totalPracticeTimeKey) ?? 0;
    } catch (e) {
      print('ERROR: Failed to get total practice time: $e');
      return 0;
    }
  }

  /// Add practice time in minutes
  Future<void> addPracticeTime(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentTime = await getTotalPracticeTime();
      await prefs.setInt(_totalPracticeTimeKey, currentTime + minutes);

      // Update the last practice session timestamp
      await _updateLastPracticeSession();

      print(
        'DEBUG: Added $minutes minutes to practice time (total: ${currentTime + minutes})',
      );
    } catch (e) {
      print('ERROR: Failed to add practice time: $e');
    }
  }

  /// Get the date of the last practice session
  Future<DateTime?> getLastPracticeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastPracticeSessionKey);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      print('ERROR: Failed to get last practice session: $e');
      return null;
    }
  }

  /// Update the last practice session timestamp to now
  Future<void> _updateLastPracticeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastPracticeSessionKey, now);
      print(
        'DEBUG: Updated last practice session timestamp: ${DateTime.fromMillisecondsSinceEpoch(now)}',
      );
    } catch (e) {
      print('ERROR: Failed to update last practice session: $e');
    }
  }

  /// Cache AI response for future reference
  Future<void> cacheAIResponse(String userInput, String aiResponse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cache = {};

      // Get existing cache or create new one
      final existingCache = prefs.getString(_aiResponseCacheKey);
      if (existingCache != null) {
        cache = jsonDecode(existingCache) as Map<String, dynamic>;
      }

      // Add new response to cache (limit to 50 entries)
      cache[userInput] = aiResponse;

      // If cache is too large, remove oldest entries
      if (cache.length > 50) {
        final keys = cache.keys.toList();
        keys.sort(); // This will roughly sort by insertion order if keys are timestamped
        for (int i = 0; i < keys.length - 50; i++) {
          cache.remove(keys[i]);
        }
      }

      // Save updated cache
      await prefs.setString(_aiResponseCacheKey, jsonEncode(cache));

      // Update timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastUpdateTimeKey, timestamp);

      print(
        'DEBUG: Cached AI response for input: "${userInput.substring(0, userInput.length > 20 ? 20 : userInput.length)}..."',
      );
    } catch (e) {
      print('ERROR: Failed to cache AI response: $e');
    }
  }

  /// Get cached AI response if available
  Future<String?> getCachedAIResponse(String userInput) async {
    try {
      if (!(await isCacheValid())) {
        print('DEBUG: AI response cache expired');
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString(_aiResponseCacheKey);

      if (cacheJson == null) return null;

      final cache = jsonDecode(cacheJson) as Map<String, dynamic>;
      final response = cache[userInput] as String?;

      if (response != null) {
        print(
          'DEBUG: Using cached AI response for input: "${userInput.substring(0, userInput.length > 20 ? 20 : userInput.length)}..."',
        );
      }

      return response;
    } catch (e) {
      print('ERROR: Failed to get cached AI response: $e');
      return null;
    }
  }

  /// Log practice session to history
  Future<void> logPracticeSession(int durationMinutes, int wordsLearned) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> history = [];

      // Get existing history or create new one
      final existingHistory = prefs.getString(_practiceHistoryKey);
      if (existingHistory != null) {
        final List<dynamic> decoded = jsonDecode(existingHistory);
        history = decoded.cast<Map<String, dynamic>>().toList();
      }

      // Add new session to history
      final session = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'duration': durationMinutes,
        'wordsLearned': wordsLearned,
      };

      history.add(session);

      // Limit history to last 100 sessions
      if (history.length > 100) {
        history = history.sublist(history.length - 100);
      }

      // Save updated history
      await prefs.setString(_practiceHistoryKey, jsonEncode(history));
      print(
        'DEBUG: Logged practice session: $durationMinutes minutes, $wordsLearned words learned',
      );
    } catch (e) {
      print('ERROR: Failed to log practice session: $e');
    }
  }

  /// Get practice session history
  Future<List<Map<String, dynamic>>> getPracticeHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_practiceHistoryKey);

      if (historyJson == null) return [];

      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.cast<Map<String, dynamic>>().toList();
    } catch (e) {
      print('ERROR: Failed to get practice history: $e');
      return [];
    }
  }

  /// Check if cache is still valid
  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateTime = prefs.getInt(_lastUpdateTimeKey);

      if (lastUpdateTime == null) {
        print('DEBUG: No practice cache timestamp found');
        return false;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - lastUpdateTime;

      // Cache is valid if it's less than the defined duration
      return difference <= _cacheValidDuration.inMilliseconds;
    } catch (e) {
      print('ERROR: Error checking practice cache validity: $e');
      return false;
    }
  }

  /// Invalidate the cache (force refresh)
  Future<void> invalidateCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdateTimeKey);
      print('DEBUG: Practice cache invalidated');
    } catch (e) {
      print('ERROR: Failed to invalidate practice cache: $e');
    }
  }

  /// Clear all cached data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_aiResponseCacheKey);
      await prefs.remove(_lastUpdateTimeKey);
      print('DEBUG: All practice cache cleared');
    } catch (e) {
      print('ERROR: Failed to clear practice cache: $e');
    }
  }
}
