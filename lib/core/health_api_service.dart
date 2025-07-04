import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('$baseUrl/api/health/award-coins');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-admin-secret': adminSecret,
      },
      body: jsonEncode({
        'userId': userId,
        'chapterId': chapterId,
        'correctAnswers': correctAnswers,
        'totalQuestions': totalQuestions,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to award coins, XP, and health: ${response.body}',
      );
    }
  }
}
