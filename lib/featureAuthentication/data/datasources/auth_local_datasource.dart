import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/auth_constants.dart';
import '../../domain/models/user.dart';

/// Local data source for authentication using SharedPreferences
class AuthLocalDataSource {
  /// Get current user from local storage
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AuthConstants.userKey);

      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save user to local storage
  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(AuthConstants.userKey, userJson);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AuthConstants.tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Save token to local storage
  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AuthConstants.tokenKey, token);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AuthConstants.isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Set login status
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AuthConstants.isLoggedInKey, isLoggedIn);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AuthConstants.userKey);
      await prefs.remove(AuthConstants.tokenKey);
      await prefs.remove(AuthConstants.isLoggedInKey);
    } catch (e) {
      // Handle error silently or log it
    }
  }
}
