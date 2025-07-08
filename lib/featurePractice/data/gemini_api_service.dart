import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/repositories/practice_repository.dart';

class GeminiApiService {
  final String apiKey;
  final PracticeRepository? practiceRepository;
  String _conversationHistory = '';
  final int _maxHistoryLength = 5; // Keep track of last 5 exchanges
  int _historyCount = 0;

  GeminiApiService(this.apiKey, {this.practiceRepository});

  Future<String> getBearResponse(String userText) async {
    // Detect Indonesian (very basic, you can improve this)
    final isIndonesian = RegExp(
      r'\b(saya|kamu|dan|tidak|apa|iya|tidak|bagaimana|dimana|mengapa|siapa|berapa|dengan|untuk|ke|di|dari|ini|itu|ada|adalah|akan|bisa|mau|pergi|makan|minum|teman|selamat|pagi|siang|malam|terima kasih|tolong|maaf)\b',
      caseSensitive: false,
    ).hasMatch(userText);
    if (isIndonesian) {
      return "I'm sorry, I don't understand Indonesian. Can we speak in English?";
    }

    // First check if we have a cached response
    if (practiceRepository != null) {
      final cachedResponse = await practiceRepository!.getCachedAIResponse(
        userText,
      );
      if (cachedResponse != null) {
        // Add to conversation history but return the cached response
        _conversationHistory += 'User: $userText\n';
        _conversationHistory += 'Dr. Hiro: $cachedResponse\n';
        _historyCount++;
        print('DEBUG: Using cached AI response for practice session');
        return cachedResponse;
      }
    }

    // Add the user's message to the conversation history
    _conversationHistory += 'User: $userText\n';
    _historyCount++;

    // Bear character system prompt
    final bearPrompt =
        '''You are Dr. Hiro, a friendly, helpful bear character in a language learning app. 
You should respond in a warm, friendly manner while helping the user practice English.
Keep your responses short (1-3 sentences maximum) and conversational.
Use simple vocabulary suitable for language learners.
Occasionally use bear-related expressions (like "bear with me" or "paw-sitive") but don't overdo it.
If the user asks about languages, give them encouragement and simple tips.
''';

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "$bearPrompt\n\nConversation History:\n$_conversationHistory\n\nDr. Hiro (bear):",
            },
          ],
        },
      ],
      "generationConfig": {
        "temperature": 0.7,
        "topP": 1,
        "maxOutputTokens": 150,
        "stopSequences": [],
      },
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      if (text != null && text is String) {
        final bearResponse = text.trim();

        // Add the bear's response to the conversation history
        _conversationHistory += 'Dr. Hiro (bear): $bearResponse\n';

        // Trim history if it gets too long
        if (_historyCount > _maxHistoryLength) {
          final lines = _conversationHistory.split('\n');
          _conversationHistory = lines
              .sublist(2)
              .join('\n'); // Remove oldest exchange
          _historyCount--;
        }

        // Cache the response for future use
        if (practiceRepository != null) {
          practiceRepository!.cacheAIResponse(userText, bearResponse);
          print('DEBUG: Caching new AI response for future use');
        }

        return bearResponse;
      }
    }
    return "Sorry, I couldn't understand. Please try again.";
  }
}
