// API Service Provider for accessing shared API functionality
import '../services/api_client.dart';
import '../../features/auth/constants/constants.dart';

class ApiServiceProvider {
  // Singleton instance
  static final ApiServiceProvider _instance = ApiServiceProvider._internal();

  // Factory constructor to return the singleton instance
  factory ApiServiceProvider() {
    return _instance;
  }

  // Internal private constructor
  ApiServiceProvider._internal();

  // Create a shared instance of ApiClient
  final ApiClient apiClient = ApiClient(
    baseUrl: AuthConstants.baseUrl,
    adminSecret: AuthConstants.adminSecret,
  );

  // Clean up resources when app is closed
  void dispose() {
    apiClient.dispose();
  }
}
