import '../../domain/repositories/practice_repository.dart';
import '../datasources/practice_local_datasource.dart';

/// Implementation of PracticeRepository
class PracticeRepositoryImpl implements PracticeRepository {
  final PracticeLocalDataSource _localDataSource;

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
}
