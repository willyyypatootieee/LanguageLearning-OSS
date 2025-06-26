import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/auth_constants.dart';
import '../../domain/models/auth_request.dart';
import '../../domain/models/auth_response.dart';

/// Remote data source for authentication API calls
class AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Login user with API
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('${AuthConstants.baseUrl}${AuthConstants.loginEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return AuthResponse(success: false, message: 'Network error: $e');
    }
  }

  /// Register user with API
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('${AuthConstants.baseUrl}${AuthConstants.registerEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: responseData['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      return AuthResponse(success: false, message: 'Network error: $e');
    }
  }

  /// Check if token is valid (admin check)
  Future<bool> checkTokenValidity(String token) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${AuthConstants.baseUrl}${AuthConstants.adminCheckEndpoint}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'admin_secret': AuthConstants.adminSecret,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData['success'] == true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
