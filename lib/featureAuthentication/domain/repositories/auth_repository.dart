import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login user with email/username and password
  Future<AuthResponse> login(LoginRequest request);

  /// Register new user
  Future<AuthResponse> register(RegisterRequest request);

  /// Get current user from local storage
  Future<User?> getCurrentUser();

  /// Save user and token to local storage
  Future<void> saveUserData(User user, String token);

  /// Clear all authentication data
  Future<void> clearAuthData();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get stored token
  Future<String?> getToken();

  /// Check if current token is valid (admin check)
  Future<bool> isTokenValid();
}
