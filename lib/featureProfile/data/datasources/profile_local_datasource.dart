import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/profile_constants.dart';
import '../../domain/models/profile_user.dart';

/// Local data source for profile using SharedPreferences
class ProfileLocalDataSource {
  /// Get cached profile from local storage
  Future<ProfileUser?> getCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(ProfileConstants.profileKey);

      if (profileJson != null) {
        // Check if cache is still valid
        if (await _isCacheValid()) {
          final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
          return ProfileUser.fromJson(profileMap);
        } else {
          // Clear expired cache
          await clearCache();
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Cache profile to local storage
  Future<void> cacheProfile(ProfileUser profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await Future.wait([
        prefs.setString(ProfileConstants.profileKey, profileJson),
        prefs.setInt(ProfileConstants.profileTimestampKey, timestamp),
      ]);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Check if cached profile exists
  Future<bool> hasCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(ProfileConstants.profileKey) &&
          await _isCacheValid();
    } catch (e) {
      return false;
    }
  }

  /// Clear cached profile data
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.remove(ProfileConstants.profileKey),
        prefs.remove(ProfileConstants.profileTimestampKey),
      ]);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Check if cache is still valid based on timestamp
  Future<bool> _isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(ProfileConstants.profileTimestampKey);

      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference.inHours < ProfileConstants.cacheValidityHours;
    } catch (e) {
      return false;
    }
  }
}
