import 'package:flutter/material.dart';
import '../controllers/profile_screen_controller.dart';
import '../models/profile_model.dart';

/// ViewModel for the profile screen that handles business logic and state management
class ProfileViewModel extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _userProfile != null;

  /// Loads the user profile from the repository
  Future<void> loadUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch profile data using the controller
      final profile = await ProfileScreenController.getUserProfile();
      _userProfile = profile;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat profil: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add friend functionality
  Future<bool> addFriend() async {
    if (_userProfile == null) return false;

    try {
      final result = await ProfileScreenController.addFriend(
        _userProfile!.username,
      );
      return result;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan teman: $e';
      notifyListeners();
      return false;
    }
  }

  /// Refresh the profile data
  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  /// Map model badges to UI badge items
  List<BadgeInfo> getBadges() {
    if (_userProfile == null) return [];
    return _userProfile!.badges;
  }

  /// Get display values for UI
  String get displayName => _userProfile?.name ?? 'User';
  String get displayUsername => _userProfile?.username ?? '@username';
  String get displayJoinDate =>
      _userProfile?.joinDate ?? 'Bergabung baru-baru ini';
  String get displayCourseCount => _userProfile?.courseCount ?? '0';
  String get displayFollowingCount => _userProfile?.followingCount ?? '0';
  String get displayFollowerCount => _userProfile?.followerCount ?? '0';
  String get displayDayStreak => _userProfile?.dayStreak ?? '0';
  String get displayTotalXP => _userProfile?.totalXP ?? '0';
  String get displayCurrentLeague => _userProfile?.currentLeague ?? 'Pemula';
  String get displayLanguageScore => _userProfile?.languageScore ?? '0';
  String get displayLanguageCode => _userProfile?.languageCode ?? 'ID';
  bool get showLanguageFlag => (_userProfile?.languageCode ?? '').isNotEmpty;
}
