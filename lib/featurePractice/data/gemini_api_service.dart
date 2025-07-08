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
    // Handle short or empty inputs gracefully
    if (userText.trim().isEmpty) {
      return "I didn't quite catch that. Could you say something in English?";
    }

    if (userText.trim().length < 3) {
      // For very short inputs, provide an encouraging response instead of error
      return "I heard a sound! Could you say a bit more for me to understand?";
    }

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
    try {
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

      // Handle API errors gracefully with a variety of fallback responses
      print(
        'ERROR: API response issue: ${response.statusCode} - ${response.body}',
      );

      // Use an expanded set of backup responses based on user input patterns
      // This helps avoid repetitive "sorry" messages and provides better conversation flow
      final lowerText = userText.toLowerCase();

      // Greeting patterns
      if (lowerText.contains("hello") ||
          lowerText.contains("hi") ||
          lowerText.contains("hey")) {
        return "Hello there! It's beary nice to meet you. How are you doing today?";
      }
      // Questions about the bear
      else if (lowerText.contains("how are you") ||
          lowerText.contains("how do you feel")) {
        return "I'm doing pawsitively great today! Thanks for asking. How about you?";
      } else if (lowerText.contains("name") ||
          lowerText.contains("who are you")) {
        return "I'm Dr. Hiro, your friendly bear language buddy! I'm here to help you practice English.";
      }
      // Questions about learning
      else if (lowerText.contains("learn") ||
          lowerText.contains("study") ||
          lowerText.contains("practice")) {
        return "Learning English takes practice, but you're doing great! Would you like to talk about a specific topic?";
      }
      // Questions or statements about likes/preferences
      else if (lowerText.contains("like") ||
          lowerText.contains("enjoy") ||
          lowerText.contains("favorite")) {
        return "That's interesting! I enjoy helping people learn English. What other things do you like?";
      }
      // General questions
      else if (lowerText.contains("?") ||
          lowerText.startsWith("what") ||
          lowerText.startsWith("why") ||
          lowerText.startsWith("how") ||
          lowerText.startsWith("when") ||
          lowerText.startsWith("where")) {
        return "Good question! I think the best way to learn is through conversation like this. Can you tell me more?";
      }
      // Very short inputs that might not be recognized well
      else if (lowerText.length < 10) {
        return "I'm listening! Can you say a bit more so we can have a good conversation?";
      }
      // Default encouraging response
      else {
        // Rotate through several default responses to avoid repetition
        final defaultResponses = [
          "That's interesting! Can you tell me more about that?",
          "I'd love to hear more of your thoughts on this topic.",
          "Let's keep this conversation going! What else would you like to discuss?",
          "You're doing great with your English! Would you like to try another topic?",
          "I'm enjoying our chat! What would you like to talk about next?",
        ];
        return defaultResponses[DateTime.now().second %
            defaultResponses.length];
      }
    } catch (e) {
      print('ERROR: Exception in API processing: $e');
      // Rotate through several error responses
      final errorResponses = [
        "I'm here to help you practice English. Let's talk about something!",
        "Let's keep chatting! What would you like to talk about?",
        "Sorry for the confusion. Can we try a different topic?",
        "I'd love to hear more about your interests. What do you enjoy doing?",
        "English practice is all about conversation. What shall we discuss next?",
      ];
      return errorResponses[DateTime.now().second % errorResponses.length];
    }
  }
}
