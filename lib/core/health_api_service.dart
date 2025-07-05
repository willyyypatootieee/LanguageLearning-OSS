import 'dart:convert';
import 'package:http/http.dart' as http;
import '../featureAuthentication/data/datasources/auth_local_datasource.dart';

class HealthApiService {
  final String baseUrl;
  final String adminSecret;
  HealthApiService({required this.baseUrl, required this.adminSecret});

  Future<Map<String, dynamic>> awardCoinsXPAndHealth({
    required String userId,
    required String chapterId,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    // Get the user's authentication token
    final authLocal = AuthLocalDataSource();
    final token = await authLocal.getToken();
    final currentUser = await authLocal.getCurrentUser();

    print('=== Health API Debug Info ===');
    print('Health API - userId parameter: $userId');
    print('Health API - currentUser from storage: ${currentUser?.id}');
    print('Health API - chapterId: $chapterId');
    print('Health API - correctAnswers: $correctAnswers');
    print('Health API - totalQuestions: $totalQuestions');
    print(
      'Health API - token: ${token != null ? "exists (${token.substring(0, 10)}...)" : "null"}',
    );

    if (token == null) {
      throw Exception('No authentication token found. User needs to log in.');
    }

    final url = Uri.parse('$baseUrl/api/health/award-coins');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Admin-Secret': adminSecret,
      'x-user-id': userId, // Add the user ID header as requested
    };

    final requestBody = {
      'userId': userId,
      'chapterId': chapterId,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
    };

    print('Health API - URL: $url');
    print('Health API - Headers: ${headers.keys.toList()}');
    print('Health API - Request body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('Health API - response status: ${response.statusCode}');
    print('Health API - response headers: ${response.headers}');
    print('Health API - response body: ${response.body}');
    print('=== End Health API Debug ===');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to award coins, XP, and health: ${response.body}',
      );
    }
  }
}
