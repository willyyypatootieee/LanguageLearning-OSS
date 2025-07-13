import 'package:flutter/foundation.dart';
import '../../domain/models/user_search_result.dart';
import '../../domain/usecases/accept_friend_request_usecase.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../../domain/usecases/get_pending_friend_requests_usecase.dart';
import '../../domain/usecases/reject_friend_request_usecase.dart';
import '../../domain/usecases/remove_friend_usecase.dart';
import '../../domain/usecases/send_friend_request_usecase.dart';
import 'feed_state.dart';

mixin FriendManagement on ChangeNotifier {
  SendFriendRequestUsecase? _sendFriendRequestUsecase;
  GetFriendsUsecase? _getFriendsUsecase;
  GetPendingFriendRequestsUsecase? _getPendingFriendRequestsUsecase;
  AcceptFriendRequestUsecase? _acceptFriendRequestUsecase;
  RejectFriendRequestUsecase? _rejectFriendRequestUsecase;
  RemoveFriendUsecase? _removeFriendUsecase;
  late FeedState state;

  set sendFriendRequestUsecase(SendFriendRequestUsecase usecase) =>
      _sendFriendRequestUsecase = usecase;
  set getFriendsUsecase(GetFriendsUsecase usecase) =>
      _getFriendsUsecase = usecase;
  set getPendingFriendRequestsUsecase(
    GetPendingFriendRequestsUsecase usecase,
  ) => _getPendingFriendRequestsUsecase = usecase;
  set acceptFriendRequestUsecase(AcceptFriendRequestUsecase usecase) =>
      _acceptFriendRequestUsecase = usecase;
  set rejectFriendRequestUsecase(RejectFriendRequestUsecase usecase) =>
      _rejectFriendRequestUsecase = usecase;
  set removeFriendUsecase(RemoveFriendUsecase usecase) =>
      _removeFriendUsecase = usecase;

  Future<void> loadFriends() async {
    state = state.copyWith(isLoadingFriends: true);
    notifyListeners();

    try {
      if (_getFriendsUsecase == null) {
        throw Exception('GetFriendsUsecase not initialized');
      }
      final friends = await _getFriendsUsecase!();
      state = state.copyWith(friends: friends);
    } catch (e) {
      print('Error loading friends: $e');
    } finally {
      state = state.copyWith(isLoadingFriends: false);
      notifyListeners();
    }
  }

  Future<void> loadPendingRequests() async {
    state = state.copyWith(isLoadingRequests: true);
    notifyListeners();

    try {
      if (_getPendingFriendRequestsUsecase == null) {
        throw Exception('GetPendingFriendRequestsUsecase not initialized');
      }
      final requests = await _getPendingFriendRequestsUsecase!();
      state = state.copyWith(pendingRequests: requests);
    } catch (e) {
      print('Error loading pending requests: $e');
    } finally {
      state = state.copyWith(isLoadingRequests: false);
      notifyListeners();
    }
  }

  Future<bool> acceptFriendRequest(String requestId) async {
    try {
      if (_acceptFriendRequestUsecase == null) {
        throw Exception('AcceptFriendRequestUsecase not initialized');
      }
      await _acceptFriendRequestUsecase!(requestId);

      final updatedRequests =
          state.pendingRequests
              .where((request) => request.id != requestId)
              .toList();
      state = state.copyWith(pendingRequests: updatedRequests);

      await loadFriends();
      return true;
    } catch (e) {
      print('Error accepting friend request: $e');
      return false;
    }
  }

  Future<bool> rejectFriendRequest(String requestId) async {
    try {
      if (_rejectFriendRequestUsecase == null) {
        throw Exception('RejectFriendRequestUsecase not initialized');
      }
      await _rejectFriendRequestUsecase!(requestId);

      final updatedRequests =
          state.pendingRequests
              .where((request) => request.id != requestId)
              .toList();
      state = state.copyWith(pendingRequests: updatedRequests);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error rejecting friend request: $e');
      return false;
    }
  }

  Future<bool> removeFriend(String friendId) async {
    try {
      if (_removeFriendUsecase == null) {
        throw Exception('RemoveFriendUsecase not initialized');
      }
      await _removeFriendUsecase!(friendId);

      final updatedFriends =
          state.friends.where((friend) => friend.id != friendId).toList();

      final updatedSearchResults =
          state.userSearchResults.map((user) {
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

      state = state.copyWith(
        friends: updatedFriends,
        userSearchResults: updatedSearchResults,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print('Error removing friend: $e');
      return false;
    }
  }

  Future<bool> sendFriendRequest(String username) async {
    try {
      if (_sendFriendRequestUsecase == null) {
        throw Exception('SendFriendRequestUsecase not initialized');
      }
      await _sendFriendRequestUsecase!(username);

      final updatedSearchResults =
          state.userSearchResults.map((user) {
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

      state = state.copyWith(userSearchResults: updatedSearchResults);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error sending friend request: $e');
      return false;
    }
  }

  bool isFriend(String userId) {
    return state.friends.any((friend) => friend.id == userId);
  }

  bool hasPendingRequest(String userId) {
    return state.pendingRequests.any(
      (request) => request.friendId == userId || request.userId == userId,
    );
  }

  int get friendsCount => state.friends.length;
  int get pendingRequestsCount => state.pendingRequests.length;
}
