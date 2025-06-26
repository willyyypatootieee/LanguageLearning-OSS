/// Repository interface for onboarding data operations
abstract class OnboardingRepository {
  /// Check if the user has completed onboarding
  Future<bool> hasCompletedOnboarding();

  /// Mark onboarding as completed
  Future<void> completeOnboarding();

  /// Check if the user is logged in
  Future<bool> isUserLoggedIn();

  /// Set user login status
  Future<void> setUserLoggedIn(bool isLoggedIn);

  /// Clear all user data
  Future<void> clearUserData();

  /// Reset onboarding status (useful for testing)
  Future<void> resetOnboarding();
}
