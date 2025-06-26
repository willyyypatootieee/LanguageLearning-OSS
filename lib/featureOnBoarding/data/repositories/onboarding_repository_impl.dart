import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

/// Implementation of OnboardingRepository using local data source
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  OnboardingRepositoryImpl(this._localDataSource);

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await _localDataSource.hasCompletedOnboarding();
  }

  @override
  Future<void> completeOnboarding() async {
    await _localDataSource.completeOnboarding();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await _localDataSource.isUserLoggedIn();
  }

  @override
  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await _localDataSource.setUserLoggedIn(isLoggedIn);
  }

  @override
  Future<void> clearUserData() async {
    await _localDataSource.clearUserData();
  }

  @override
  Future<void> resetOnboarding() async {
    await _localDataSource.resetOnboarding();
  }
}
