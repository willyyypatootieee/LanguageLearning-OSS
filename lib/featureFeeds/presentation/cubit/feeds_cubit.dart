import 'package:flutter/foundation.dart';
import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';
import '../../domain/models/user_search_result.dart';
import '../../domain/models/friend.dart';
import '../../domain/models/friend_request.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../domain/usecases/send_friend_request_usecase.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../../domain/usecases/get_pending_friend_requests_usecase.dart';
import '../../domain/usecases/accept_friend_request_usecase.dart';
import '../../domain/usecases/reject_friend_request_usecase.dart';
import '../../domain/usecases/remove_friend_usecase.dart';

/// Cubit for managing feeds state
class FeedsCubit extends ChangeNotifier {
  final GetPostsUsecase _getPostsUsecase;
  final CreatePostUsecase _createPostUsecase;
  final SearchUsersUsecase _searchUsersUsecase;
  final SendFriendRequestUsecase _sendFriendRequestUsecase;
  final GetFriendsUsecase _getFriendsUsecase;
  final GetPendingFriendRequestsUsecase _getPendingFriendRequestsUsecase;
  final AcceptFriendRequestUsecase _acceptFriendRequestUsecase;
  final RejectFriendRequestUsecase _rejectFriendRequestUsecase;
  final RemoveFriendUsecase _removeFriendUsecase;

  bool _isDisposed = false;
  bool _hasInitiallyLoaded = false;

  FeedsCubit(
    this._getPostsUsecase,
    this._createPostUsecase,
    this._searchUsersUsecase,
    this._sendFriendRequestUsecase,
    this._getFriendsUsecase,
    this._getPendingFriendRequestsUsecase,
    this._acceptFriendRequestUsecase,
    this._rejectFriendRequestUsecase,
    this._removeFriendUsecase,
  );

  List<Post> _posts = [];
  List<Post> _originalPosts = [];
  bool _isLoading = false;
  bool _isCreatingPost = false;
  String? _errorMessage;
  String _searchQuery = '';

  Map<String, dynamic> _currentFilters = {};

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isCreatingPost => _isCreatingPost;
  String? get errorMessage => _errorMessage;
  bool get hasInitiallyLoaded => _hasInitiallyLoaded;
  String get searchQuery => _searchQuery;
  Map<String, dynamic> get currentFilters => _currentFilters;

  List<UserSearchResult> _userSearchResults = [];
  bool _isSearchingUsers = false;

  // Friend management state
  List<Friend> _friends = [];
  List<FriendRequest> _pendingRequests = [];
  bool _isLoadingFriends = false;
  bool _isLoadingRequests = false;

  List<UserSearchResult> get userSearchResults => _userSearchResults;
  bool get isSearchingUsers => _isSearchingUsers;
  List<Friend> get friends => _friends;
  List<FriendRequest> get pendingRequests => _pendingRequests;
  bool get isLoadingFriends => _isLoadingFriends;
  bool get isLoadingRequests => _isLoadingRequests;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _setCreatingPost(bool creating) {
    _isCreatingPost = creating;
    _safeNotifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    _safeNotifyListeners();
  }

  /// Load posts feed
  Future<void> loadPosts({bool forceRefresh = false}) async {
    // If we have cached data and not forcing refresh, don't show loading
    if (_hasInitiallyLoaded && !forceRefresh) {
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final posts = await _getPostsUsecase();
      _originalPosts = posts;

      // Apply current search and filters
      _applyCurrentFilters();

      _hasInitiallyLoaded = true;
      _setLoading(false);
    } catch (e) {
      print('Error loading posts in cubit: $e');
      // Don't show error to user for server errors, just log them
      _setLoading(false);
      _hasInitiallyLoaded =
          true; // Still mark as loaded to prevent infinite loading
    }
  }

  /// Create a new post
  Future<bool> createPost(
    String content, {
    String? imageUrl,
    String? parentId,
  }) async {
    if (content.trim().isEmpty) {
      _setError('Post content cannot be empty');
      return false;
    }

    _setCreatingPost(true);
    _setError(null);

    try {
      final request = CreatePostRequest(
        content: content.trim(),
        imageUrl: imageUrl,
        parentId: parentId,
      );

      await _createPostUsecase(request);

      _setCreatingPost(false);

      // Always refresh posts after attempting to create
      await loadPosts(forceRefresh: true);

      // Return true to indicate successful creation (posts will be refreshed)
      return true;
    } catch (e) {
      _setCreatingPost(false);
      // Still try to refresh in case the post was created despite the error
      await loadPosts(forceRefresh: true);
      print('Error creating post: $e');
      // Don't show error message, just log it
      return false;
    }
  }

  /// Refresh posts feed
  Future<void> refreshPosts() async {
    await loadPosts(forceRefresh: true);
  }

  /// Search posts by content, username, or other criteria
  void searchPosts(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyCurrentFilters();
  }

  /// Clear search and show all posts
  void clearSearch() {
    _searchQuery = '';
    _applyCurrentFilters();
  }

  /// Clear error message
  void clearError() {
    _setError(null);
  }

  /// Apply filters to posts
  void applyFilters(Map<String, dynamic> filters) {
    _currentFilters = filters;
    _applyCurrentFilters();
  }

  /// Apply current filters and search to posts
  void _applyCurrentFilters() {
    List<Post> filteredPosts = List.from(_originalPosts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredPosts =
          filteredPosts.where((post) {
            final contentMatch = post.content.toLowerCase().contains(
              _searchQuery,
            );
            final authorMatch = post.author.username.toLowerCase().contains(
              _searchQuery,
            );
            final rankMatch = post.author.currentRank.toLowerCase().contains(
              _searchQuery,
            );
            return contentMatch || authorMatch || rankMatch;
          }).toList();
    }

    // Apply rank filter
    if (_currentFilters['rank'] != null && _currentFilters['rank'] != 'Semua') {
      String rankFilter = _currentFilters['rank'];
      // Map Indonesian rank names to English
      Map<String, String> rankMapping = {
        'Pemula': 'BEGINNER',
        'Perunggu': 'BRONZE',
        'Perak': 'SILVER',
        'Emas': 'GOLD',
        'Platinum': 'PLATINUM',
        'Berlian': 'DIAMOND',
      };

      String englishRank = rankMapping[rankFilter] ?? rankFilter.toUpperCase();
      filteredPosts =
          filteredPosts
              .where(
                (post) => post.author.currentRank.toUpperCase() == englishRank,
              )
              .toList();
    }

    // Apply image filter
    if (_currentFilters['onlyWithImages'] == true) {
      filteredPosts =
          filteredPosts
              .where(
                (post) => post.imageUrl != null && post.imageUrl!.isNotEmpty,
              )
              .toList();
    }

    // Apply sorting
    String sortOption = _currentFilters['sort'] ?? 'Terbaru';
    switch (sortOption) {
      case 'Terbaru':
        filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Terpopuler':
        filteredPosts.sort((a, b) {
          int aReactions =
              a.reactionsCount?.values.fold<int>(
                0,
                (sum, count) => sum + count,
              ) ??
              0;
          int bReactions =
              b.reactionsCount?.values.fold<int>(
                0,
                (sum, count) => sum + count,
              ) ??
              0;
          return bReactions.compareTo(aReactions);
        });
        break;
      case 'XP Tertinggi':
        filteredPosts.sort(
          (a, b) => b.author.totalXp.compareTo(a.author.totalXp),
        );
        break;
      case 'Streak Terpanjang':
        filteredPosts.sort(
          (a, b) => b.author.streakDay.compareTo(a.author.streakDay),
        );
        break;
    }

    _posts = filteredPosts;
    _safeNotifyListeners();
  }

  /// Search for users
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      _userSearchResults = [];
      _safeNotifyListeners();
      return;
    }

    _isSearchingUsers = true;
    _safeNotifyListeners();

    try {
      final results = await _searchUsersUsecase(query.trim());
      _userSearchResults = results;
    } catch (e) {
      print('Error searching users: $e');
      _userSearchResults = [];
    } finally {
      _isSearchingUsers = false;
      _safeNotifyListeners();
    }
  }

  /// Send friend request to a user
  Future<bool> sendFriendRequest(String username) async {
    try {
      await _sendFriendRequestUsecase(username);

      // Update the search results to reflect the pending request
      _userSearchResults =
          _userSearchResults.map((user) {
            if (user.username == username) {
              return UserSearchResult(
                id: user.id,
                username: user.username,
                email: user.email,
                totalXp: user.totalXp,
                streakDay: user.streakDay,
                currentRank: user.currentRank,
                isFriend: user.isFriend,
                hasPendingRequest: true,
              );
            }
            return user;
          }).toList();

      _safeNotifyListeners();
      return true;
    } catch (e) {
      print('Error sending friend request: $e');
      return false;
    }
  }

  /// Clear user search results
  void clearUserSearch() {
    _userSearchResults = [];
    _safeNotifyListeners();
  }

  /// Load friends list
  Future<void> loadFriends() async {
    _isLoadingFriends = true;
    _safeNotifyListeners();

    try {
      final friends = await _getFriendsUsecase();
      _friends = friends;
    } catch (e) {
      print('Error loading friends: $e');
    } finally {
      _isLoadingFriends = false;
      _safeNotifyListeners();
    }
  }

  /// Load pending friend requests
  Future<void> loadPendingRequests() async {
    _isLoadingRequests = true;
    _safeNotifyListeners();

    try {
      final requests = await _getPendingFriendRequestsUsecase();
      _pendingRequests = requests;
    } catch (e) {
      print('Error loading pending requests: $e');
    } finally {
      _isLoadingRequests = false;
      _safeNotifyListeners();
    }
  }

  /// Accept a friend request
  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      await _acceptFriendRequestUsecase(requestId);

      // Remove the request from pending list
      _pendingRequests.removeWhere((request) => request.id == requestId);

      // Refresh friends list to include the new friend
      await loadFriends();

      _safeNotifyListeners();
      return true;
    } catch (e) {
      print('Error accepting friend request: $e');
      return false;
    }
  }

  /// Reject a friend request
  Future<bool> rejectFriendRequest(String requestId) async {
    try {
      await _rejectFriendRequestUsecase(requestId);

      // Remove the request from pending list
      _pendingRequests.removeWhere((request) => request.id == requestId);

      _safeNotifyListeners();
      return true;
    } catch (e) {
      print('Error rejecting friend request: $e');
      return false;
    }
  }

  /// Remove a friend
  Future<bool> removeFriend(String friendId) async {
    try {
      await _removeFriendUsecase(friendId);

      // Remove the friend from friends list
      _friends.removeWhere((friend) => friend.id == friendId);

      // Update user search results if they exist
      _userSearchResults =
          _userSearchResults.map((user) {
            if (user.id == friendId) {
              return UserSearchResult(
                id: user.id,
                username: user.username,
                email: user.email,
                totalXp: user.totalXp,
                streakDay: user.streakDay,
                currentRank: user.currentRank,
                isFriend: false,
                hasPendingRequest: user.hasPendingRequest,
              );
            }
            return user;
          }).toList();

      _safeNotifyListeners();
      return true;
    } catch (e) {
      print('Error removing friend: $e');
      return false;
    }
  }

  /// Get total number of friends
  int get friendsCount => _friends.length;

  /// Get total number of pending requests
  int get pendingRequestsCount => _pendingRequests.length;

  /// Check if a user is already a friend
  bool isFriend(String userId) {
    return _friends.any((friend) => friend.id == userId);
  }

  /// Check if there's a pending request for a user
  bool hasPendingRequest(String userId) {
    return _pendingRequests.any(
      (request) => request.friendId == userId || request.userId == userId,
    );
  }
}
