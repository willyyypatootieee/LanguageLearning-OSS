import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/profile_constants.dart';
import '../../domain/models/profile_user.dart';
import '../../domain/models/profile_request.dart';

/// Remote data source for profile API calls
class ProfileRemoteDataSource {
  final http.Client _client;

  ProfileRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Get user profile by ID from API
  Future<ProfileUser?> getUserProfile(String userId, String token) async {
    try {
      final url =
          '${ProfileConstants.baseUrl}${ProfileConstants.getUserEndpoint(userId)}';
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Admin-Secret': 'bellingadmin',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          return ProfileUser.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      return null; // Return null instead of throwing exception
    }
  }

  /// Update user profile via API
  Future<bool> updateProfile(
    String userId,
    String token,
    UpdateProfileRequest request,
  ) async {
    try {
      if (request.isEmpty) return false;
      final response = await _client.put(
        Uri.parse(
          '${ProfileConstants.baseUrl}${ProfileConstants.getUserEndpoint(userId)}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Admin-Secret': 'bellingadmin',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData['success'] == true;
      }

      return false;
    } catch (e) {
      throw Exception('${ProfileConstants.updateFailedError}: $e');
    }
  }

  /// Dispose of the HTTP client
  void dispose() {
    _client.close();
  }
}
