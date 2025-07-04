import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey;
  GeminiApiService(this.apiKey);

  Future<String> getBearResponse(String userText) async {
    // Detect Indonesian (very basic, you can improve this)
    final isIndonesian = RegExp(
      r'\b(saya|kamu|dan|tidak|apa|iya|tidak|bagaimana|dimana|mengapa|siapa|berapa|dengan|untuk|ke|di|dari|ini|itu|ada|adalah|akan|bisa|mau|pergi|makan|minum|teman|selamat|pagi|siang|malam|terima kasih|tolong|maaf)\b',
      caseSensitive: false,
    ).hasMatch(userText);
    if (isIndonesian) {
      return "I'm not recognize that, sorry.";
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userText},
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topP": 1,
        "maxOutputTokens": 128,
        "stopSequences": [],
      },
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (text != null && text is String) {
        return text.trim();
      }
    }
    return "Sorry, I couldn't understand. Please try again.";
  }
}
