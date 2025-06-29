import 'package:flutter/foundation.dart';
import '../../domain/models/profile_user.dart';
import '../../domain/usecases/get_current_profile_usecase.dart';
import '../../domain/repositories/profile_repository.dart';

/// Cubit for profile state management
class ProfileCubit extends ChangeNotifier {
  final GetCurrentProfileUseCase _getCurrentProfileUseCase;
  final ProfileRepository _repository;

  bool _isDisposed = false;

  ProfileCubit(this._getCurrentProfileUseCase, this._repository);

  ProfileUser? _user;
  bool _isLoading = false;
  String? _error;

  ProfileUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Load cached profile instantly, then update with remote data in background
  Future<void> loadProfile() async {
    _setError(null);
    // Try to load cached profile first
    final cached = await _repository.getCachedProfile();
    if (cached != null) {
      _user = cached;
      _safeNotifyListeners();
    } else {
      _setLoading(true);
    }
    // Always try to fetch latest from remote in background
    try {
      final profile = await _getCurrentProfileUseCase();
      _user = profile;
      if (profile == null) {
        _setError('Failed to load profile');
      }
    } catch (e) {
      if (!_isDisposed) {
        _setError('An error occurred while loading profile: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  /// Refresh profile data (force reload from remote)
  Future<void> refreshProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      final profile = await _getCurrentProfileUseCase();
      _user = profile;
      if (profile == null) {
        _setError('Failed to load profile');
      }
    } catch (e) {
      if (!_isDisposed) {
        _setError('An error occurred while loading profile: $e');
      }
    } finally {
      if (!_isDisposed) {
        _setLoading(false);
      }
    }
  }

  /// Clear profile data
  void clearProfile() {
    _user = null;
    _error = null;
    _safeNotifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    _safeNotifyListeners();
  }
}
