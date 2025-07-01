import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for practice feature
class PracticeLocalDataSource {
  static const String _practiceOnboardingKey = 'practice_onboarding_completed';
  static const String _practiceStreakKey = 'practice_streak';
  static const String _totalPracticeTimeKey = 'total_practice_time';

  /// Check if practice onboarding has been completed
  Future<bool> isPracticeOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_practiceOnboardingKey) ?? false;
  }

  /// Mark practice onboarding as completed
  Future<void> completePracticeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_practiceOnboardingKey, true);
  }

  /// Get current practice streak
  Future<int> getPracticeStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_practiceStreakKey) ?? 0;
  }

  /// Set practice streak
  Future<void> setPracticeStreak(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_practiceStreakKey, streak);
  }

  /// Get total practice time in minutes
  Future<int> getTotalPracticeTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalPracticeTimeKey) ?? 0;
  }

  /// Add practice time in minutes
  Future<void> addPracticeTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = await getTotalPracticeTime();
    await prefs.setInt(_totalPracticeTimeKey, currentTime + minutes);
  }
}
