/// Post model representing a social media post
class Post {
  final String id;
  final String authorId;
  final String content;
  final String? imageUrl;
  final String? parentId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final PostAuthor author;
  final Map<String, int>? reactionsCount;
  final List<Post>? replies;

  const Post({
    required this.id,
    required this.authorId,
    required this.content,
    this.imageUrl,
    this.parentId,
    required this.createdAt,
    this.deletedAt,
    required this.author,
    this.reactionsCount,
    this.replies,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Handle case where author information might be missing (e.g., in create post response)
    PostAuthor author;
    if (json['author'] != null) {
      author = PostAuthor.fromJson(json['author'] as Map<String, dynamic>);
    } else {
      // Create a minimal placeholder author using authorId
      author = PostAuthor(
        id: json['author_id'] as String,
        username: 'User', // Placeholder username
        scoreEnglish: 0,
        streakDay: 0,
        totalXp: 0,
        currentRank: 'Wood', // Default rank
      );
    }

    return Post(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      parentId: json['parent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'] as String)
              : null,
      author: author,
      reactionsCount:
          json['reactions_count'] != null
              ? Map<String, int>.from(json['reactions_count'] as Map)
              : null,
      replies:
          json['replies'] != null
              ? (json['replies'] as List<dynamic>)
                  .map((reply) => Post.fromJson(reply as Map<String, dynamic>))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
      if (parentId != null) 'parent_id': parentId,
      'created_at': createdAt.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
      'author': author.toJson(),
      if (reactionsCount != null) 'reactions_count': reactionsCount,
      if (replies != null)
        'replies': replies!.map((reply) => reply.toJson()).toList(),
    };
  }
}

/// Post author model
class PostAuthor {
  final String id;
  final String username;
  final String? email;
  final int scoreEnglish;
  final int streakDay;
  final int totalXp;
  final String currentRank;
  final DateTime? createdAt;

  const PostAuthor({
    required this.id,
    required this.username,
    this.email,
    required this.scoreEnglish,
    required this.streakDay,
    required this.totalXp,
    required this.currentRank,
    this.createdAt,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    // Handle potentially missing fields with null-safety
    // This makes the parsing more resilient to API changes and incomplete data
    return PostAuthor(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? 'Unknown User',
      email: json['email'] as String?,
      // Safely handle cases where these fields might be missing in the API response
      scoreEnglish: _parseIntSafely(json, 'score_english'),
      streakDay: _parseIntSafely(json, 'streak_day'),
      totalXp: _parseIntSafely(json, 'total_xp'),
      currentRank: json['current_rank'] as String? ?? 'Wood',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  // Helper method to safely parse integer values
  static int _parseIntSafely(Map<String, dynamic> json, String key) {
    // If the field is missing or not an integer, return 0 as default
    if (!json.containsKey(key)) return 0;

    final value = json[key];
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        print('Error parsing $key as int: $e');
        return 0;
      }
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      'score_english': scoreEnglish,
      'streak_day': streakDay,
      'total_xp': totalXp,
      'current_rank': currentRank,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
