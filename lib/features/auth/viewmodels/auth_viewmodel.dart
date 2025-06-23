import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/models.dart';

// Status enum untuk AuthViewModel
// Status enum for AuthViewModel
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

// ViewModel untuk mengelola state autentikasi
// ViewModel to manage authentication state
class AuthViewModel extends ChangeNotifier {
  final AuthController _authController = AuthController();

  AuthStatus _status = AuthStatus.initial;
  UserModel? _currentUser;
  String _errorMessage = '';

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isError => _status == AuthStatus.error;

  // Constructor
  AuthViewModel() {
    _initAuthStatus();
  }

  // Check if user is logged in
  // Memeriksa apakah pengguna sudah login
  Future<bool> isLoggedIn() async {
    return await _authController.isLoggedIn();
  }

  // Inisialisasi status autentikasi saat aplikasi dibuka
  // Initialize authentication status when app opens
  Future<void> _initAuthStatus() async {
    _setLoading();
    try {
      final isLoggedIn = await _authController.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _authController.getCurrentUser();
        _setAuthenticated();
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      _setError('Gagal memuat status autentikasi');
    }
  }

  // Fungsi pendaftaran
  // Registration function
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    _setLoading();
    try {
      final result = await _authController.register(
        username: username,
        email: email,
        password: password,
        birthDate: birthDate,
      );

      if (result.success && result.data != null) {
        _currentUser = result.data!.user;
        _setAuthenticated();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan saat mendaftar: $e');
      return false;
    }
  }

  // Fungsi login
  // Login function
  Future<bool> login({
    String? email,
    String? username,
    required String password,
  }) async {
    _setLoading();
    try {
      final result = await _authController.login(
        email: email,
        username: username,
        password: password,
      );

      if (result.success && result.data != null) {
        _currentUser = result.data!.user;
        _setAuthenticated();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan saat login: $e');
      return false;
    }
  }

  // Fungsi logout
  // Logout function
  Future<void> logout() async {
    _setLoading();
    try {
      await _authController.logout();
      _currentUser = null;
      _setUnauthenticated();
    } catch (e) {
      _setError('Terjadi kesalahan saat logout: $e');
    }
  }

  // Fungsi pembaruan profil
  // Profile update function
  Future<bool> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? password,
  }) async {
    _setLoading();
    try {
      final result = await _authController.updateProfile(
        userId: userId,
        username: username,
        email: email,
        password: password,
      );

      if (result.success) {
        // Refresh user data
        _currentUser = await _authController.getCurrentUser();
        _setAuthenticated();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan saat memperbarui profil: $e');
      return false;
    }
  }

  // Fungsi hapus akun
  // Account deletion function
  Future<bool> deleteAccount(String userId) async {
    _setLoading();
    try {
      final result = await _authController.deleteAccount(userId);

      if (result.success) {
        _currentUser = null;
        _setUnauthenticated();
        return true;
      } else {
        _setError(result.message);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan saat menghapus akun: $e');
      return false;
    }
  }

  // Helper methods to update state
  void _setLoading() {
    _status = AuthStatus.loading;
    notifyListeners();
  }

  void _setAuthenticated() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_status == AuthStatus.error) {
      _status =
          _currentUser != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
