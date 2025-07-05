import '../../domain/models/post.dart';
import '../../domain/models/post_request.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';
import '../datasources/post_local_datasource.dart';

/// Implementation of PostRepository
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;
  final PostLocalDataSource _localDataSource;

  PostRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Post>> getPosts() async {
    try {
      final token = await _localDataSource.getToken();
      print('DEBUG: Retrieved token from local storage: $token');
      if (token == null) {
        print('DEBUG: Token is null, returning empty list');
        return [];
      }

      return await _remoteDataSource.getPosts(token);
    } catch (e) {
      print('DEBUG: Exception in repository getPosts: $e');
      return [];
    }
  }

  @override
  Future<Post?> createPost(CreatePostRequest request) async {
    try {
      final token = await _localDataSource.getToken();
      if (token == null) {
        return null;
      }

      return await _remoteDataSource.createPost(request, token);
    } catch (e) {
      return null;
    }
  }
}
