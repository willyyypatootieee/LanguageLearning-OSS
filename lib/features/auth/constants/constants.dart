// constants.dart - Constants for authentication feature

// API URL constants
class AuthConstants {
  // Base API URL
  static const String baseUrl = 'https://beling-4ef8e653eda6.herokuapp.com';

  // Admin secret for authentication
  static const String adminSecret = 'bellingadmin';

  // Auth endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';

  // User endpoints
  static const String userEndpoint = '/api/users';

  // SharedPreferences keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
