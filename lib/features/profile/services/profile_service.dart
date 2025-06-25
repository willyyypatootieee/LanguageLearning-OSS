import 'dart:convert';

import '../../../core/providers/api_service_provider.dart';
import '../../../core/services/api_client.dart';
import '../../../features/auth/constants/constants.dart';
import '../../../features/auth/services/auth_service.dart';
import '../models/models.dart';

/// Service to manage profile data operations
class ProfileService {
  // Get API client from the centralized provider
  final ApiClient _apiClient = ApiServiceProvider().apiClient;
  final AuthService _authService = AuthService();

  /// Get the current user's profile
  Future<UserProfile> getCurrentUserProfile() async {
    try {
      // Get user profile from the API
      final userModel = await _authService.getCurrentUser();

      if (userModel != null) {
        // Convert UserModel to UserProfile
        return UserProfile(
          name: userModel.username,
          username: '@${userModel.username.toLowerCase()}',
          joinDate: 'Bergabung ${_formatJoinDate(userModel.createdAt)}',
          courseCount: '1+', // Default value
          followingCount: '0', // Default value
          followerCount: '0', // Default value
          dayStreak: userModel.streakDay.toString(),
          totalXP: userModel.totalXp.toString(),
          currentLeague: userModel.currentRank,
          languageScore: userModel.scoreEnglish.toString(),
          languageCode: 'US', // Default for English
          badges: [
            BadgeInfo(
              type: BadgeType.celebration,
              isEarned: userModel.totalXp > 100,
            ),
            BadgeInfo(type: BadgeType.star, isEarned: userModel.streakDay > 7),
            BadgeInfo(type: BadgeType.medal, isEarned: userModel.totalXp > 500),
            BadgeInfo(
              type: BadgeType.trophy,
              isEarned: userModel.totalXp > 1000,
            ),
          ],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      // Fallback to mock data if there's an error
      return UserProfile.mock();
    }
  }

  // Format join date
  String _formatJoinDate(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Update the user's profile information
  Future<bool> updateUserProfile(UserProfile updatedProfile) async {
    try {
      final token = await _authService.getToken();
      final userModel = await _authService.getCurrentUser();

      if (userModel == null || token == null) {
        return false;
      }

      // Extract username without @ prefix
      String username = updatedProfile.username;
      if (username.startsWith('@')) {
        username = username.substring(1);
      }

      // Make the API call to update the profile
      await _apiClient.put(
        '${AuthConstants.userEndpoint}/${userModel.id}',
        body: {
          'username': username,
          // Add other fields as needed
        },
        token: token,
      );

      return true;
    } catch (e) {
      // Fallback to simulate success for now
      return true;
    }
  }

  /// Add a user as friend
  Future<bool> addFriend(String username) async {
    try {
      final token = await _authService.getToken();
      final currentUser = await _authService.getCurrentUser();

      if (currentUser == null || token == null) {
        return false;
      }

      // This endpoint might not exist yet - replace with the actual endpoint
      // For now, just simulate a successful request
      /*
      await _apiClient.post(
        '/api/friends',
        body: {
          'userId': currentUser.id,
          'friendUsername': username,
        },
        token: token,
      );
      */

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      return true;
    } catch (e) {
      // Fallback to simulate success for now
      return true;
    }
  }

  /// Get monthly badges for the current user
  Future<List<BadgeInfo>> getMonthlyBadges() async {
    try {
      final currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('User not found');
      }

      // Create badges based on user's stats
      return [
        BadgeInfo(
          type: BadgeType.celebration,
          isEarned: currentUser.totalXp > 100,
        ),
        BadgeInfo(type: BadgeType.star, isEarned: currentUser.streakDay > 7),
        BadgeInfo(type: BadgeType.medal, isEarned: currentUser.totalXp > 500),
        BadgeInfo(type: BadgeType.trophy, isEarned: currentUser.totalXp > 1000),
      ];
    } catch (e) {
      // Return default badges if there's an error
      return [
        BadgeInfo(type: BadgeType.celebration, isEarned: true),
        BadgeInfo(type: BadgeType.star, isEarned: true),
        BadgeInfo(type: BadgeType.medal, isEarned: false),
        BadgeInfo(type: BadgeType.trophy, isEarned: false),
      ];
    }
  }
}
