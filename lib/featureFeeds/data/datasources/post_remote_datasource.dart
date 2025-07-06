import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/feeds_constants.dart';
import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';

/// Remote data source for posts API calls
class PostRemoteDataSource {
  final http.Client _client;

  PostRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  /// Get posts feed from API (admin auth only)
  Future<List<Post>> getPosts() async {
    try {
      final url = '${FeedsConstants.baseUrl}${FeedsConstants.postsEndpoint}';
      print('DEBUG: [GET] $url');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Admin-Secret': FeedsConstants.adminSecret,
      };
      print('DEBUG: Headers: ${headers.toString()}');

      final response = await _client
          .get(Uri.parse(url), headers: headers)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('DEBUG: Request timed out after 10 seconds');
              throw TimeoutException('Request timed out');
            },
          );

      print('DEBUG: Response Status: ${response.statusCode}');
      print('DEBUG: Response Headers: ${response.headers}');
      print('DEBUG: Response Body: ${_formatJson(response.body)}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          final postsData = responseData['data'] as List<dynamic>;
          print('DEBUG: Successfully parsed ${postsData.length} posts');

          // Debug: Inspect the total_xp field in each post's author
          for (var post in postsData) {
            if (post is Map<String, dynamic> &&
                post['author'] is Map<String, dynamic>) {
              print(
                'DEBUG: Post author totalXp: ${post['author']['total_xp']}',
              );
            }
          }

          return postsData
              .map(
                (postJson) => Post.fromJson(postJson as Map<String, dynamic>),
              )
              .toList();
        } else {
          print('DEBUG: API returned success=false or null data');
          print('DEBUG: Message: ${responseData['message'] ?? 'No message'}');
          return [];
        }
      } else if (response.statusCode == 403) {
        print('DEBUG: Forbidden - Check admin secret');
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        print('DEBUG: Server error - Check server logs');
        print('DEBUG: Response: ${_formatJson(response.body)}');
        throw ServerException();
      } else {
        print('DEBUG: Unknown error ${response.statusCode}');
        print('DEBUG: Response: ${_formatJson(response.body)}');
        return [];
      }
    } catch (e, stack) {
      print('DEBUG: Exception in getPosts: ${e.toString()}');
      print('DEBUG: Stack trace: $stack');
      return [];
    }
  }

  /// Create a new post via API (requires user ID)
  Future<Post?> createPost(CreatePostRequest request, String userId) async {
    try {
      final url = '${FeedsConstants.baseUrl}${FeedsConstants.postsEndpoint}';
      print('DEBUG: [POST] $url');
      print('DEBUG: User ID: $userId');

      final requestBody = request.toJson();
      print('DEBUG: Request Body: ${_formatJson(jsonEncode(requestBody))}');

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Admin-Secret': FeedsConstants.adminSecret,
        'X-User-Id': userId,
      };
      print('DEBUG: Headers: ${headers.toString()}');

      final response = await _client
          .post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('DEBUG: Request timed out after 10 seconds');
              throw TimeoutException('Request timed out');
            },
          );

      print('DEBUG: Response Status: ${response.statusCode}');
      print('DEBUG: Response Headers: ${response.headers}');
      print('DEBUG: Response Body: ${_formatJson(response.body)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          return Post.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          print('DEBUG: API returned success=false or null data');
          print('DEBUG: Message: ${responseData['message'] ?? 'No message'}');
          return null;
        }
      } else if (response.statusCode == 403) {
        print('DEBUG: Forbidden - Check admin secret and user ID');
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        print('DEBUG: Server error - Check server logs');
        print('DEBUG: Response: ${_formatJson(response.body)}');
        throw ServerException();
      } else {
        print('DEBUG: Unknown error ${response.statusCode}');
        print('DEBUG: Response: ${_formatJson(response.body)}');
        return null;
      }
    } catch (e, stack) {
      print('DEBUG: Exception in createPost: $e');
      print('DEBUG: Stack trace: $stack');
      return null;
    }
  }

  String _formatJson(String jsonString) {
    try {
      final object = jsonDecode(jsonString);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(object);
    } catch (e) {
      return jsonString;
    }
  }
}

class ForbiddenException implements Exception {}

class ServerException implements Exception {}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}
