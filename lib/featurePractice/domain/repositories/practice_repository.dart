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
}
