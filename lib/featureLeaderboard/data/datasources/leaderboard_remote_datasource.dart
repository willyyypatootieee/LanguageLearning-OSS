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
    final response = await dio.get(
      '$baseUrl/api/users',
      options: Options(headers: {'x-admin-secret': adminSecret}),
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      final List users = response.data['data'];
      return users.map((json) => LeaderboardUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch leaderboard users');
    }
  }
}
