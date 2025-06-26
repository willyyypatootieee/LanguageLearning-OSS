import '../../domain/models/auth_request.dart';
import '../../domain/models/auth_response.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../featureOnBoarding/data/datasources/onboarding_local_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);

      if (response.success && response.user != null && response.token != null) {
        // Save user data locally
        await saveUserData(response.user!, response.token!);
      }

      return response;
    } catch (e) {
      return AuthResponse(success: false, message: 'Failed to login: $e');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _remoteDataSource.register(request);

      if (response.success && response.user != null && response.token != null) {
        // Save user data locally
        await saveUserData(response.user!, response.token!);
      }

      return response;
    } catch (e) {
      return AuthResponse(success: false, message: 'Failed to register: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return await _localDataSource.getCurrentUser();
  }

  @override
  Future<void> saveUserData(User user, String token) async {
    await Future.wait([
      _localDataSource.saveUser(user),
      _localDataSource.saveToken(token),
      _localDataSource.setLoggedIn(true),
    ]);
  }

  @override
  Future<void> clearAuthData() async {
    await _localDataSource.clearAuthData();

    // Also clear onboarding login status to keep systems in sync
    try {
      final onboardingLocalDataSource = OnboardingLocalDataSource();
      await onboardingLocalDataSource.setUserLoggedIn(false);
    } catch (e) {
      // Handle silently - onboarding data clearing is secondary
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }

  @override
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  @override
  Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      return await _remoteDataSource.checkTokenValidity(token);
    } catch (e) {
      return false;
    }
  }
}
