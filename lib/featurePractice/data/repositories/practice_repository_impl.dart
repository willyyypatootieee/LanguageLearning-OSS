import '../../domain/repositories/practice_repository.dart';
import '../datasources/practice_local_datasource.dart';

/// Implementation of PracticeRepository
class PracticeRepositoryImpl implements PracticeRepository {
  final PracticeLocalDataSource _localDataSource;

  // In-memory cache for faster access
  final Map<String, String> _aiResponseMemoryCache = {};

  PracticeRepositoryImpl(this._localDataSource);

  @override
  Future<bool> isPracticeOnboardingCompleted() {
    return _localDataSource.isPracticeOnboardingCompleted();
  }

  @override
  Future<void> completePracticeOnboarding() {
    return _localDataSource.completePracticeOnboarding();
  }

  @override
  Future<int> getPracticeStreak() {
    return _localDataSource.getPracticeStreak();
  }

  @override
  Future<void> updatePracticeStreak(int streak) {
    return _localDataSource.setPracticeStreak(streak);
  }

  @override
  Future<int> getTotalPracticeTime() {
    return _localDataSource.getTotalPracticeTime();
  }

  @override
  Future<void> addPracticeTime(int minutes) {
    return _localDataSource.addPracticeTime(minutes);
  }

  @override
  Future<DateTime?> getLastPracticeSession() {
    return _localDataSource.getLastPracticeSession();
  }

  @override
  Future<void> cacheAIResponse(String userInput, String aiResponse) async {
    // Update both memory and persistent cache
    _aiResponseMemoryCache[userInput] = aiResponse;
    await _localDataSource.cacheAIResponse(userInput, aiResponse);
  }

  @override
  Future<String?> getCachedAIResponse(
    String userInput, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      print('DEBUG: Skipping AI response cache due to force refresh');
      return null;
    }

    // First check memory cache (fastest)
    if (_aiResponseMemoryCache.containsKey(userInput)) {
      print('DEBUG: Using memory-cached AI response');
      return _aiResponseMemoryCache[userInput];
    }

    // Then check persistent cache
    final persistentCache = await _localDataSource.getCachedAIResponse(
      userInput,
    );

    // Update memory cache if found in persistent cache
    if (persistentCache != null) {
      _aiResponseMemoryCache[userInput] = persistentCache;
    }

    return persistentCache;
  }

  @override
  Future<void> logPracticeSession(int durationMinutes, int wordsLearned) {
    return _localDataSource.logPracticeSession(durationMinutes, wordsLearned);
  }

  @override
  Future<List<Map<String, dynamic>>> getPracticeHistory() {
    return _localDataSource.getPracticeHistory();
  }

  @override
  Future<void> invalidateCache() async {
    // Clear memory cache
    _aiResponseMemoryCache.clear();
    // Clear persistent cache
    await _localDataSource.invalidateCache();
  }
}
