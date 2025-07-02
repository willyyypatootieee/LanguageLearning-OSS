import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/chapter_constants.dart';
import '../../domain/models/chapter.dart';

/// Remote data source for chapters and lessons API calls
class ChapterRemoteDataSource {
  final http.Client _client;

  ChapterRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Get all chapters from API
  Future<List<Chapter>> getChapters() async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.chaptersEndpoint}';
      print('Fetching chapters from: $url'); // Debug log
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> chaptersJson =
              responseData['data'] as List<dynamic>;
          return chaptersJson
              .map(
                (chapterJson) =>
                    Chapter.fromJson(chapterJson as Map<String, dynamic>),
              )
              .toList();
        }
      }
      throw Exception(
        '${ChapterConstants.fetchFailedError}: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      print('Error fetching chapters: $e'); // Debug log
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Get chapter by ID with lessons
  Future<Chapter?> getChapterById(String chapterId) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.getChapterEndpoint(chapterId)}';
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          return Chapter.fromJson(responseData['data'] as Map<String, dynamic>);
        }
      } else if (response.statusCode == 404) {
        return null;
      }
      throw Exception(
        '${ChapterConstants.fetchFailedError}: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Get lesson by ID with questions
  Future<Lesson?> getLessonById(String lessonId) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.getLessonEndpoint(lessonId)}';
      print('Fetching lesson from: $url'); // Debug log
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      print('Lesson response status: ${response.statusCode}'); // Debug log
      print('Lesson response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          print('Parsing lesson data: ${responseData['data']}'); // Debug log

          // Handle both single object and array responses
          final data = responseData['data'];
          if (data is Map<String, dynamic>) {
            return Lesson.fromJson(data);
          } else if (data is List<dynamic> && data.isNotEmpty) {
            return Lesson.fromJson(data.first as Map<String, dynamic>);
          } else {
            print('Lesson data is empty or invalid format'); // Debug log
            return null;
          }
        }
      } else if (response.statusCode == 404) {
        return null;
      }
      throw Exception(
        '${ChapterConstants.fetchFailedError}: ${response.statusCode}',
      );
    } catch (e) {
      print('Error in getLessonById: $e'); // Debug log
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Get question choices
  Future<List<Choice>> getQuestionChoices(String questionId) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.getQuestionChoicesEndpoint(questionId)}';
      print('Fetching choices from: $url'); // Debug log
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      print('Choices response status: ${response.statusCode}'); // Debug log
      print('Choices response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> choicesJson =
              responseData['data'] as List<dynamic>;
          return choicesJson
              .map(
                (choiceJson) =>
                    Choice.fromJson(choiceJson as Map<String, dynamic>),
              )
              .toList();
        }
      }
      throw Exception(
        '${ChapterConstants.fetchFailedError}: ${response.statusCode}',
      );
    } catch (e) {
      print('Error in getQuestionChoices: $e'); // Debug log
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Submit answer for a question
  Future<bool> submitAnswer({
    required String questionId,
    required String userAnswer,
    required bool isCorrect,
  }) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.submitAnswerEndpoint()}';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
        body: jsonEncode({
          'question_id': questionId,
          'user_answer': userAnswer,
          'is_correct': isCorrect,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return responseData['success'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Complete a lesson
  Future<Map<String, dynamic>?> completeLesson(String lessonId) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.completeLessonEndpoint(lessonId)}';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      throw Exception('${ChapterConstants.networkError}: $e');
    }
  }

  /// Update user XP using PUT method
  Future<Map<String, dynamic>?> updateUserXp({
    required int xpGained,
    required String lessonId,
    required int score,
    required int totalQuestions,
  }) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.updateUserXpEndpoint()}';
      final response = await _client.put(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
        body: jsonEncode({
          'xp_gained': xpGained,
          'lesson_id': lessonId,
          'score': score,
          'total_questions': totalQuestions,
          'completion_percentage': (score / totalQuestions * 100).round(),
        }),
      );

      print('PUT updateUserXp response status: ${response.statusCode}');
      print('PUT updateUserXp response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      print('Error updating user XP: $e');
      return null;
    }
  }

  /// Add coins to user using PUT method
  Future<Map<String, dynamic>?> addUserCoins({
    required int coinsEarned,
    required String reason,
  }) async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.addUserCoinsEndpoint()}';
      final response = await _client.put(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
        body: jsonEncode({'coins_earned': coinsEarned, 'reason': reason}),
      );

      print('PUT addUserCoins response status: ${response.statusCode}');
      print('PUT addUserCoins response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true) {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
      return null;
    } catch (e) {
      print('Error adding user coins: $e');
      return null;
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final url =
          '${ChapterConstants.baseUrl}${ChapterConstants.getUserProgressEndpoint()}';
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': ChapterConstants.contentType,
          'Accept': ChapterConstants.accept,
          'X-Admin-Secret': ChapterConstants.adminSecret,
        },
      );

      print('GET getUserProfile response status: ${response.statusCode}');
      print('GET getUserProfile response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Dispose of the HTTP client
  void dispose() {
    _client.close();
  }
}
