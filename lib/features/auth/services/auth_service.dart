import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/models.dart';

// Service untuk mengelola autentikasi dengan API
// Service to manage authentication with API
class AuthService {
  // URL API
  final String baseUrl = AuthConstants.baseUrl;

  // Header untuk request HTTP
  Map<String, String> _headers() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // Menambahkan token ke header jika tersedia
  // Add token to header if available
  Future<Map<String, String>> _authHeaders() async {
    final headers = _headers();
    final token = await getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Mendaftarkan pengguna baru
  // Register a new user
  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AuthConstants.registerEndpoint}'),
        headers: _headers(),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'birthDate':
              birthDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
        }),
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponseModel.fromJson(responseData);

      // Simpan token dan data pengguna jika berhasil
      // Save token and user data if successful
      if (authResponse.success && authResponse.data != null) {
        await _saveAuthData(authResponse.data!);
      }

      return authResponse;
    } catch (e) {
      return AuthResponseModel(
        success: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  // Login pengguna
  // User login
  Future<AuthResponseModel> login({
    String? email,
    String? username,
    required String password,
  }) async {
    try {
      // Setidaknya salah satu email atau username harus disediakan
      // At least one of email or username must be provided
      if (email == null && username == null) {
        throw Exception('Email atau username diperlukan');
      }

      final requestBody = {'password': password};

      if (email != null) requestBody['email'] = email;
      if (username != null) requestBody['username'] = username;

      final response = await http.post(
        Uri.parse('$baseUrl${AuthConstants.loginEndpoint}'),
        headers: _headers(),
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);
      final authResponse = AuthResponseModel.fromJson(responseData);

      // Simpan token dan data pengguna jika berhasil
      // Save token and user data if successful
      if (authResponse.success && authResponse.data != null) {
        await _saveAuthData(authResponse.data!);
      }

      return authResponse;
    } catch (e) {
      return AuthResponseModel(
        success: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  // Simpan data autentikasi ke SharedPreferences
  // Save authentication data to SharedPreferences
  Future<void> _saveAuthData(AuthData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthConstants.tokenKey, data.token);
    await prefs.setString(
      AuthConstants.userKey,
      jsonEncode(data.user.toJson()),
    );
  }

  // Ambil token dari SharedPreferences
  // Get token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthConstants.tokenKey);
  }

  // Ambil data pengguna dari SharedPreferences
  // Get user data from SharedPreferences
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(AuthConstants.userKey);
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Keluar dari aplikasi (logout)
  // Log out from the application
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthConstants.tokenKey);
    await prefs.remove(AuthConstants.userKey);
  }

  // Periksa apakah pengguna sudah login
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Update profil pengguna
  // Update user profile
  Future<AuthResponseModel> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? password,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (username != null) updateData['username'] = username;
      if (email != null) updateData['email'] = email;
      if (password != null) updateData['password'] = password;

      if (updateData.isEmpty) {
        return AuthResponseModel(
          success: false,
          message: 'Tidak ada data yang diperbarui',
        );
      }

      final headers = await _authHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: headers,
        body: jsonEncode(updateData),
      );

      final responseData = jsonDecode(response.body);
      return AuthResponseModel.fromJson(responseData);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }

  // Hapus akun pengguna
  // Delete user account
  Future<AuthResponseModel> deleteAccount(String userId) async {
    try {
      final headers = await _authHeaders();

      final response = await http.delete(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: headers,
      );

      final responseData = jsonDecode(response.body);

      // Hapus data lokal jika berhasil
      // Delete local data if successful
      if (response.statusCode == 200) {
        await logout();
      }

      return AuthResponseModel.fromJson(responseData);
    } catch (e) {
      return AuthResponseModel(
        success: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }
}
