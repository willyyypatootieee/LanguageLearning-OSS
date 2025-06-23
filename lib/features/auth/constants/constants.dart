// constants.dart - Constants for authentication feature

// API URL constants
class AuthConstants {
  // Base API URL
  static const String baseUrl = 'https://beling-4ef8e653eda6.herokuapp.com';

  // Auth endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';

  // SharedPreferences keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
