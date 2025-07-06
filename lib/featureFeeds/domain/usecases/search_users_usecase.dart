import '../models/user_search_result.dart';

/// Use case for searching users
abstract class SearchUsersUsecase {
  Future<List<UserSearchResult>> call(String query);
}

class SearchUsersUsecaseImpl implements SearchUsersUsecase {
  @override
  Future<List<UserSearchResult>> call(String query) async {
    // This would be replaced with an actual API call in production
    await Future.delayed(const Duration(milliseconds: 300));

    // Return empty list - would be populated from API in production
    return [];
  }
}
