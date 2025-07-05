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
      // For GET requests, we only need admin auth
      return await _remoteDataSource.getPosts();
    } catch (e) {
      print('DEBUG: Exception in repository getPosts: $e');
      return [];
    }
  }

  @override
  Future<Post?> createPost(CreatePostRequest request) async {
    try {
      // For POST requests, we need the user ID
      final userId = await _localDataSource.getUserId();
      if (userId == null) {
        print('DEBUG: Cannot create post - User ID is null');
        return null;
      }

      return await _remoteDataSource.createPost(request, userId);
    } catch (e) {
      print('DEBUG: Exception in repository createPost: $e');
      return null;
    }
  }
}
