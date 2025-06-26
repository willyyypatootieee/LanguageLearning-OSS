import 'package:flutter/foundation.dart';
import '../../domain/models/profile_user.dart';
import '../../domain/usecases/get_current_profile_usecase.dart';

/// Cubit for profile state management
class ProfileCubit extends ChangeNotifier {
  final GetCurrentProfileUseCase _getCurrentProfileUseCase;

  ProfileCubit(this._getCurrentProfileUseCase);

  ProfileUser? _user;
  bool _isLoading = false;
  String? _error;

  ProfileUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load current user profile
  Future<void> loadProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      print('ProfileCubit: Starting to load profile...');
      final profile = await _getCurrentProfileUseCase();
      print(
        'ProfileCubit: Profile loaded: ${profile != null ? 'Success' : 'Failed'}',
      );

      _user = profile;

      if (profile == null) {
        _setError('Failed to load profile');
        print('ProfileCubit: Profile is null');
      } else {
        print('ProfileCubit: Profile loaded for user: ${profile.username}');
      }
    } catch (e) {
      print('ProfileCubit: Error loading profile: $e');
      _setError('An error occurred while loading profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Clear profile data
  void clearProfile() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
