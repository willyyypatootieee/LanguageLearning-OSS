import 'package:flutter/foundation.dart';
import '../../domain/models/post.dart';
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
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/add_reaction_usecase.dart';
import '../../domain/usecases/remove_reaction_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/get_reactions_usecase.dart';
import 'feed_state.dart';
import 'post_management.dart';
import 'friend_management.dart';
import 'search_management.dart';

/// Cubit for managing feeds state
class FeedsCubit extends ChangeNotifier
    with PostManagement, FriendManagement, SearchManagement {
  FeedsCubit(
    GetPostsUsecase getPostsUsecase,
    CreatePostUsecase createPostUsecase,
    SearchUsersUsecase searchUsersUsecase,
    SendFriendRequestUsecase sendFriendRequestUsecase,
    GetFriendsUsecase getFriendsUsecase,
    GetPendingFriendRequestsUsecase getPendingFriendRequestsUsecase,
    AcceptFriendRequestUsecase acceptFriendRequestUsecase,
    RejectFriendRequestUsecase rejectFriendRequestUsecase,
    RemoveFriendUsecase removeFriendUsecase,
    DeletePostUsecase deletePostUsecase,
    AddReactionUsecase addReactionUsecase,
    RemoveReactionUsecase removeReactionUsecase,
    GetPostByIdUsecase getPostByIdUsecase,
    GetReactionsUsecase getReactionsUsecase,
  ) {
    state = FeedState();

    // Initialize use cases for each mixin
    this.getPostsUsecase = getPostsUsecase;
    this.createPostUsecase = createPostUsecase;
    this.searchUsersUsecase = searchUsersUsecase;
    this.sendFriendRequestUsecase = sendFriendRequestUsecase;
    this.getFriendsUsecase = getFriendsUsecase;
    this.getPendingFriendRequestsUsecase = getPendingFriendRequestsUsecase;
    this.acceptFriendRequestUsecase = acceptFriendRequestUsecase;
    this.rejectFriendRequestUsecase = rejectFriendRequestUsecase;
    this.removeFriendUsecase = removeFriendUsecase;
    this.deletePostUsecase = deletePostUsecase;
    this.addReactionUsecase = addReactionUsecase;
    this.removeReactionUsecase = removeReactionUsecase;
    this.getPostByIdUsecase = getPostByIdUsecase;
    this.getReactionsUsecase = getReactionsUsecase;
  }

  // Public getters to expose state
  List<Post> get posts => state.posts;
  bool get isLoading => state.isLoading;
  bool get isCreatingPost => state.isCreatingPost;
  String? get errorMessage => state.errorMessage;
  bool get hasInitiallyLoaded => state.hasInitiallyLoaded;
  String get searchQuery => state.searchQuery;
  Map<String, dynamic> get currentFilters => state.currentFilters;
  List<UserSearchResult> get userSearchResults => state.userSearchResults;
  bool get isSearchingUsers => state.isSearchingUsers;
  List<Friend> get friends => state.friends;
  List<FriendRequest> get pendingRequests => state.pendingRequests;
  bool get isLoadingFriends => state.isLoadingFriends;
  bool get isLoadingRequests => state.isLoadingRequests;

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
    notifyListeners();
  }
}
