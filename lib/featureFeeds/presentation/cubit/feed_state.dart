import 'package:flutter/foundation.dart';
import '../../domain/models/post.dart';
import '../../domain/models/friend.dart';
import '../../domain/models/friend_request.dart';
import '../../domain/models/user_search_result.dart';

/// State class for the feeds feature
class FeedState {
  final List<Post> posts;
  final List<Post> originalPosts;
  final bool isLoading;
  final bool isCreatingPost;
  final String? errorMessage;
  final String searchQuery;
  final Map<String, dynamic> currentFilters;
  final List<UserSearchResult> userSearchResults;
  final bool isSearchingUsers;
  final List<Friend> friends;
  final List<FriendRequest> pendingRequests;
  final bool isLoadingFriends;
  final bool isLoadingRequests;
  final bool hasInitiallyLoaded;

  FeedState({
    this.posts = const [],
    this.originalPosts = const [],
    this.isLoading = false,
    this.isCreatingPost = false,
    this.errorMessage,
    this.searchQuery = '',
    this.currentFilters = const {},
    this.userSearchResults = const [],
    this.isSearchingUsers = false,
    this.friends = const [],
    this.pendingRequests = const [],
    this.isLoadingFriends = false,
    this.isLoadingRequests = false,
    this.hasInitiallyLoaded = false,
  });

  FeedState copyWith({
    List<Post>? posts,
    List<Post>? originalPosts,
    bool? isLoading,
    bool? isCreatingPost,
    String? Function()? errorMessage,
    String? searchQuery,
    Map<String, dynamic>? currentFilters,
    List<UserSearchResult>? userSearchResults,
    bool? isSearchingUsers,
    List<Friend>? friends,
    List<FriendRequest>? pendingRequests,
    bool? isLoadingFriends,
    bool? isLoadingRequests,
    bool? hasInitiallyLoaded,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      originalPosts: originalPosts ?? this.originalPosts,
      isLoading: isLoading ?? this.isLoading,
      isCreatingPost: isCreatingPost ?? this.isCreatingPost,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentFilters: currentFilters ?? this.currentFilters,
      userSearchResults: userSearchResults ?? this.userSearchResults,
      isSearchingUsers: isSearchingUsers ?? this.isSearchingUsers,
      friends: friends ?? this.friends,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      hasInitiallyLoaded: hasInitiallyLoaded ?? this.hasInitiallyLoaded,
    );
  }
}
