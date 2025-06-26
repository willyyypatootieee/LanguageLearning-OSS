/// Profile API constants
class ProfileConstants {
  // Private constructor to prevent instantiation
  ProfileConstants._();
  // API endpoints
  static const String baseUrl = 'https://beling-4ef8e653eda6.herokuapp.com';
  static const String usersEndpoint = '/api/users';

  // Build user specific endpoint
  static String getUserEndpoint(String userId) => '$usersEndpoint/$userId';

  // Local storage keys
  static const String profileKey = 'cached_profile';
  static const String profileTimestampKey = 'profile_timestamp';

  // Cache duration (in hours)
  static const int cacheValidityHours = 24;

  // Error messages
  static const String profileNotFoundError = 'Profile not found';
  static const String updateFailedError = 'Failed to update profile';
  static const String networkError = 'Network error occurred';
}
