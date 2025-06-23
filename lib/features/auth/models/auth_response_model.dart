import 'user_model.dart';

// Model respons untuk autentikasi
// Authentication response model
class AuthResponseModel {
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponseModel({required this.success, required this.message, this.data});

  // Membuat model dari JSON
  // Create model from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

// Model untuk data pada respons autentikasi
// Model for data in authentication response
class AuthData {
  final UserModel user;
  final String token;

  AuthData({required this.user, required this.token});

  // Membuat model dari JSON
  // Create model from JSON
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}
