/// Abstract repository interface for practice feature
abstract class PracticeRepository {
  /// Check if practice onboarding has been completed
  Future<bool> isPracticeOnboardingCompleted();

  /// Complete practice onboarding
  Future<void> completePracticeOnboarding();

  /// Get current practice streak
  Future<int> getPracticeStreak();

  /// Update practice streak
  Future<void> updatePracticeStreak(int streak);

  /// Get total practice time in minutes
  Future<int> getTotalPracticeTime();

  /// Add practice session time
  Future<void> addPracticeTime(int minutes);

  /// Get the date of the last practice session
  Future<DateTime?> getLastPracticeSession();

  /// Cache AI response for future reference
  Future<void> cacheAIResponse(String userInput, String aiResponse);

  /// Get cached AI response if available and valid
  Future<String?> getCachedAIResponse(
    String userInput, {
    bool forceRefresh = false,
  });

  /// Log a completed practice session to history
  Future<void> logPracticeSession(int durationMinutes, int wordsLearned);

  /// Get practice session history
  Future<List<Map<String, dynamic>>> getPracticeHistory();

  /// Invalidate the cache (force refresh)
  Future<void> invalidateCache();
}
