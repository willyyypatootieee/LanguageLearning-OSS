import '../../featureOnBoarding/data/datasources/onboarding_local_datasource.dart';
import '../../featureOnBoarding/data/repositories/onboarding_repository_impl.dart';
import '../../featureOnBoarding/domain/repositories/onboarding_repository.dart';
import '../../featureAuthentication/data/datasources/auth_local_datasource.dart';
import '../../featureAuthentication/data/datasources/auth_remote_datasource.dart';
import '../../featureAuthentication/data/repositories/auth_repository_impl.dart';
import '../../featureAuthentication/domain/repositories/auth_repository.dart';
import '../../featureFeeds/data/datasources/post_local_datasource.dart';
import '../../featureFeeds/data/datasources/post_remote_datasource.dart';
import '../../featureFeeds/data/repositories/post_repository_impl.dart';
import '../../featureFeeds/domain/repositories/post_repository.dart';
import '../../featureFeeds/domain/usecases/get_posts_usecase.dart';
import '../../featureFeeds/domain/usecases/create_post_usecase.dart';
import '../../featureFeeds/presentation/cubit/feeds_cubit.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  // Onboarding dependencies
  OnboardingLocalDataSource? _onboardingLocalDataSource;
  OnboardingRepository? _onboardingRepository;

  // Authentication dependencies
  AuthLocalDataSource? _authLocalDataSource;
  AuthRemoteDataSource? _authRemoteDataSource;
  AuthRepository? _authRepository;

  // Feeds dependencies
  PostLocalDataSource? _postLocalDataSource;
  PostRemoteDataSource? _postRemoteDataSource;
  PostRepository? _postRepository;
  GetPostsUsecase? _getPostsUsecase;
  CreatePostUsecase? _createPostUsecase;
  FeedsCubit? _feedsCubit;

  /// Get onboarding local data source
  OnboardingLocalDataSource get onboardingLocalDataSource {
    _onboardingLocalDataSource ??= OnboardingLocalDataSource();
    return _onboardingLocalDataSource!;
  }

  /// Get onboarding repository
  OnboardingRepository get onboardingRepository {
    _onboardingRepository ??= OnboardingRepositoryImpl(
      onboardingLocalDataSource,
    );
    return _onboardingRepository!;
  }

  /// Get auth local data source
  AuthLocalDataSource get authLocalDataSource {
    _authLocalDataSource ??= AuthLocalDataSource();
    return _authLocalDataSource!;
  }

  /// Get auth remote data source
  AuthRemoteDataSource get authRemoteDataSource {
    _authRemoteDataSource ??= AuthRemoteDataSource();
    return _authRemoteDataSource!;
  }

  /// Get auth repository
  AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(
      authRemoteDataSource,
      authLocalDataSource,
    );
    return _authRepository!;
  }

  /// Get post local data source
  PostLocalDataSource get postLocalDataSource {
    _postLocalDataSource ??= PostLocalDataSource();
    return _postLocalDataSource!;
  }

  /// Get post remote data source
  PostRemoteDataSource get postRemoteDataSource {
    _postRemoteDataSource ??= PostRemoteDataSource();
    return _postRemoteDataSource!;
  }

  /// Get post repository
  PostRepository get postRepository {
    _postRepository ??= PostRepositoryImpl(
      postRemoteDataSource,
      postLocalDataSource,
    );
    return _postRepository!;
  }

  /// Get posts usecase
  GetPostsUsecase get getPostsUsecase {
    _getPostsUsecase ??= GetPostsUsecase(postRepository);
    return _getPostsUsecase!;
  }

  /// Get create post usecase
  CreatePostUsecase get createPostUsecase {
    _createPostUsecase ??= CreatePostUsecase(postRepository);
    return _createPostUsecase!;
  }

  /// Get feeds cubit (singleton)
  FeedsCubit get feedsCubit {
    _feedsCubit ??= FeedsCubit(getPostsUsecase, createPostUsecase);
    return _feedsCubit!;
  }

  /// Reset all dependencies (useful for testing)
  void reset() {
    _onboardingLocalDataSource = null;
    _onboardingRepository = null;
    _authLocalDataSource = null;
    _authRemoteDataSource = null;
    _authRepository = null;
    _postLocalDataSource = null;
    _postRemoteDataSource = null;
    _postRepository = null;
    _getPostsUsecase = null;
    _createPostUsecase = null;
    _feedsCubit?.dispose();
    _feedsCubit = null;
  }
}
