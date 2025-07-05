/// Request model for creating a new post
class CreatePostRequest {
  final String content;
  final String? imageUrl;
  final String? parentId;

  const CreatePostRequest({
    required this.content,
    this.imageUrl,
    this.parentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
      if (parentId != null) 'parent_id': parentId,
    };
  }

  /// Check if the request is valid
  bool get isValid => content.trim().isNotEmpty;
}

/// Response model for API calls
class PostResponse {
  final bool success;
  final String message;
  final dynamic data;

  const PostResponse({required this.success, required this.message, this.data});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}

/// Response model for posts feed
class PostsResponse {
  final bool success;
  final int count;
  final List<dynamic> data;

  const PostsResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      data: json['data'] as List<dynamic>,
    );
  }
}
