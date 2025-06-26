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
      print('ProfileRemoteDataSource: Making API call to: $url');
      print('ProfileRemoteDataSource: User ID: $userId');
      print('ProfileRemoteDataSource: Token: ${token.substring(0, 20)}...');      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-Admin-Secret': 'bellingadmin',
        },
      );

      print('ProfileRemoteDataSource: Response status: ${response.statusCode}');
      print('ProfileRemoteDataSource: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          print('ProfileRemoteDataSource: Successfully parsed profile data');
          return ProfileUser.fromJson(responseData['data']);
        } else {
          print(
            'ProfileRemoteDataSource: API response success=false or data is null',
          );
        }
      } else {
        print(
          'ProfileRemoteDataSource: API returned error status code: ${response.statusCode}',
        );
      }      return null;
    } catch (e) {
      print('ProfileRemoteDataSource: Exception occurred: $e');
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
      if (request.isEmpty) return false;      final response = await _client.put(
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
