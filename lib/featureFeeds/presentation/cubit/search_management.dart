import 'package:flutter/foundation.dart';
import '../../domain/usecases/search_users_usecase.dart';
import 'feed_state.dart';

mixin SearchManagement on ChangeNotifier {
  SearchUsersUsecase? _searchUsersUsecase;
  late FeedState state;

  set searchUsersUsecase(SearchUsersUsecase usecase) =>
      _searchUsersUsecase = usecase;

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(userSearchResults: const []);
      notifyListeners();
      return;
    }

    state = state.copyWith(isSearchingUsers: true);
    notifyListeners();

    try {
      if (_searchUsersUsecase == null)
        throw Exception('SearchUsersUsecase not initialized');
      final results = await _searchUsersUsecase!(query.trim());
      state = state.copyWith(userSearchResults: results);
    } catch (e) {
      print('Error searching users: $e');
      state = state.copyWith(userSearchResults: const []);
    } finally {
      state = state.copyWith(isSearchingUsers: false);
      notifyListeners();
    }
  }

  void clearUserSearch() {
    state = state.copyWith(userSearchResults: const []);
    notifyListeners();
  }
}
