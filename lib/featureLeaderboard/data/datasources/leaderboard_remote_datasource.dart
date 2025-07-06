import 'package:dio/dio.dart';
import '../../domain/models/leaderboard_user.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardUser>> fetchLeaderboardUsers();
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://beling-4ef8e653eda6.herokuapp.com';
  static const String adminSecret = 'bellingadmin';

  LeaderboardRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LeaderboardUser>> fetchLeaderboardUsers() async {
    try {
      // Add cache-busting query parameter to avoid HTTP caching
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await dio.get(
        '$baseUrl/api/users?_cb=$timestamp',
        options: Options(
          headers: {'x-admin-secret': adminSecret},
          // Ensure we don't use cached responses
          extra: {'refresh': true},
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List users = response.data['data'];
        return users.map((json) => LeaderboardUser.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch leaderboard users: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch leaderboard users: $e');
    }
  }
}
