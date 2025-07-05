import 'package:shared_preferences/shared_preferences.dart';
import '../../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../../featureAuthentication/domain/models/user.dart';

/// Local data source for posts data
class PostLocalDataSource {
  final AuthLocalDataSource _authDataSource;

  PostLocalDataSource({AuthLocalDataSource? authDataSource})
    : _authDataSource = authDataSource ?? AuthLocalDataSource();

  /// Get cached user token
  Future<String?> getToken() async {
    return _authDataSource.getToken();
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    final user = await _authDataSource.getCurrentUser();
    return user?.id;
  }

  /// Clear cached data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
