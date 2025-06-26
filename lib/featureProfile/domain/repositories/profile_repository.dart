import '../models/profile_user.dart';
import '../models/profile_request.dart';

/// Repository interface for profile data operations
abstract class ProfileRepository {
  /// Get current user profile information
  Future<ProfileUser?> getCurrentProfile();

  /// Get user profile by ID
  Future<ProfileUser?> getUserProfile(String userId);

  /// Update user profile information
  Future<bool> updateProfile(String userId, UpdateProfileRequest request);

  /// Check if profile data is cached
  Future<bool> hasLocalProfile();

  /// Clear cached profile data
  Future<void> clearLocalProfile();

  /// Get cached profile
  Future<ProfileUser?> getCachedProfile();

  /// Cache profile locally
  Future<void> cacheProfile(ProfileUser profile);
}
