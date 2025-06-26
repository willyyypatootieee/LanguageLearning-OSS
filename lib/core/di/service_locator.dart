import '../../featureOnBoarding/data/datasources/onboarding_local_datasource.dart';
import '../../featureOnBoarding/data/repositories/onboarding_repository_impl.dart';
import '../../featureOnBoarding/domain/repositories/onboarding_repository.dart';
import '../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../featureAuthentication/data/repositories/auth_repository_impl.dart';
import '../../featureAuthentication/domain/repositories/auth_repository.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  // Onboarding dependencies
  OnboardingLocalDataSource? _onboardingLocalDataSource;
  OnboardingRepository? _onboardingRepository;

  // Authentication dependencies
  AuthLocalDataSource? _authLocalDataSource;
  AuthRemoteDataSource? _authRemoteDataSource;
  AuthRepository? _authRepository;

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

  /// Get auth local data source
  AuthLocalDataSource get authLocalDataSource {
    _authLocalDataSource ??= AuthLocalDataSource();
    return _authLocalDataSource!;
  }

  /// Get auth remote data source
  AuthRemoteDataSource get authRemoteDataSource {
    _authRemoteDataSource ??= AuthRemoteDataSource();
    return _authRemoteDataSource!;
  }

  /// Get auth repository
  AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(
      authRemoteDataSource,
      authLocalDataSource,
    );
    return _authRepository!;
  }

  /// Reset all dependencies (useful for testing)
  void reset() {
    _onboardingLocalDataSource = null;
    _onboardingRepository = null;
    _authLocalDataSource = null;
    _authRemoteDataSource = null;
    _authRepository = null;
  }
}
