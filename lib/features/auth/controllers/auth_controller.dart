import '../models/models.dart';
import '../services/auth_service.dart';

// Controller untuk mengelola logika autentikasi
// Controller to manage authentication logic
class AuthController {
  final AuthService _authService = AuthService();

  // Metode untuk mendaftarkan pengguna baru
  // Method to register a new user
  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    return await _authService.register(
      username: username,
      email: email,
      password: password,
      birthDate: birthDate,
    );
  }

  // Metode untuk login pengguna
  // Method to login a user
  Future<AuthResponseModel> login({
    String? email,
    String? username,
    required String password,
  }) async {
    return await _authService.login(
      email: email,
      username: username,
      password: password,
    );
  }

  // Memeriksa status login
  // Check login status
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  // Mendapatkan pengguna saat ini
  // Get current user
  Future<UserModel?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  // Logout dari aplikasi
  // Logout from the application
  Future<void> logout() async {
    await _authService.logout();
  }

  // Update profil pengguna
  // Update user profile
  Future<AuthResponseModel> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? password,
  }) async {
    return await _authService.updateProfile(
      userId: userId,
      username: username,
      email: email,
      password: password,
    );
  }

  // Hapus akun pengguna
  // Delete user account
  Future<AuthResponseModel> deleteAccount(String userId) async {
    return await _authService.deleteAccount(userId);
  }
}
