import '../../featureOnBoarding/data/datasources/onboarding_local_datasource.dart';
import '../../featureOnBoarding/data/repositories/onboarding_repository_impl.dart';
import '../../featureOnBoarding/domain/repositories/onboarding_repository.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  // Onboarding dependencies
  OnboardingLocalDataSource? _onboardingLocalDataSource;
  OnboardingRepository? _onboardingRepository;

  /// Get onboarding local data source
  OnboardingLocalDataSource get onboardingLocalDataSource {
    _onboardingLocalDataSource ??= OnboardingLocalDataSource();
    return _onboardingLocalDataSource!;
  }

  /// Get onboarding repository
  OnboardingRepository get onboardingRepository {
    _onboardingRepository ??= OnboardingRepositoryImpl(
      onboardingLocalDataSource,
    );
    return _onboardingRepository!;
  }

  /// Reset all dependencies (useful for testing)
  void reset() {
    _onboardingLocalDataSource = null;
    _onboardingRepository = null;
  }
}
