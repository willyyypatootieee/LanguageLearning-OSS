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
import '../../featureFeeds/domain/usecases/search_users_usecase.dart';
import '../../featureFeeds/domain/usecases/send_friend_request_usecase.dart';
import '../../featureFeeds/domain/usecases/get_friends_usecase.dart';
import '../../featureFeeds/domain/usecases/get_pending_friend_requests_usecase.dart';
import '../../featureFeeds/domain/usecases/accept_friend_request_usecase.dart';
import '../../featureFeeds/domain/usecases/reject_friend_request_usecase.dart';
import '../../featureFeeds/domain/usecases/remove_friend_usecase.dart';
import '../../featureFeeds/domain/usecases/delete_post_usecase.dart';
import '../../featureFeeds/domain/usecases/add_reaction_usecase.dart';
import '../../featureFeeds/domain/usecases/remove_reaction_usecase.dart';
import '../../featureFeeds/domain/usecases/get_post_by_id_usecase.dart';
import '../../featureFeeds/domain/usecases/get_reactions_usecase.dart';
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
  SearchUsersUsecase? _searchUsersUsecase;
  SendFriendRequestUsecase? _sendFriendRequestUsecase;
  GetFriendsUsecase? _getFriendsUsecase;
  GetPendingFriendRequestsUsecase? _getPendingFriendRequestsUsecase;
  AcceptFriendRequestUsecase? _acceptFriendRequestUsecase;
  RejectFriendRequestUsecase? _rejectFriendRequestUsecase;
  RemoveFriendUsecase? _removeFriendUsecase;
  DeletePostUsecase? _deletePostUsecase;
  AddReactionUsecase? _addReactionUsecase;
  RemoveReactionUsecase? _removeReactionUsecase;
  GetPostByIdUsecase? _getPostByIdUsecase;
  GetReactionsUsecase? _getReactionsUsecase;
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

  /// Get search users use case
  SearchUsersUsecase get searchUsersUsecase {
    _searchUsersUsecase ??= SearchUsersUsecaseImpl();
    return _searchUsersUsecase!;
  }

  /// Get send friend request use case
  SendFriendRequestUsecase get sendFriendRequestUsecase {
    _sendFriendRequestUsecase ??= SendFriendRequestUsecaseImpl();
    return _sendFriendRequestUsecase!;
  }

  /// Get friends use case
  GetFriendsUsecase get getFriendsUsecase {
    _getFriendsUsecase ??= GetFriendsUsecase();
    return _getFriendsUsecase!;
  }

  /// Get pending friend requests use case
  GetPendingFriendRequestsUsecase get getPendingFriendRequestsUsecase {
    _getPendingFriendRequestsUsecase ??= GetPendingFriendRequestsUsecase();
    return _getPendingFriendRequestsUsecase!;
  }

  /// Get accept friend request use case
  AcceptFriendRequestUsecase get acceptFriendRequestUsecase {
    _acceptFriendRequestUsecase ??= AcceptFriendRequestUsecase();
    return _acceptFriendRequestUsecase!;
  }

  /// Get reject friend request use case
  RejectFriendRequestUsecase get rejectFriendRequestUsecase {
    _rejectFriendRequestUsecase ??= RejectFriendRequestUsecase();
    return _rejectFriendRequestUsecase!;
  }

  /// Get remove friend use case
  RemoveFriendUsecase get removeFriendUsecase {
    _removeFriendUsecase ??= RemoveFriendUsecase();
    return _removeFriendUsecase!;
  }

  /// Get delete post use case
  DeletePostUsecase get deletePostUsecase {
    _deletePostUsecase ??= DeletePostUsecase(postRepository);
    return _deletePostUsecase!;
  }

  /// Get add reaction use case
  AddReactionUsecase get addReactionUsecase {
    _addReactionUsecase ??= AddReactionUsecase(postRepository);
    return _addReactionUsecase!;
  }

  /// Get remove reaction use case
  RemoveReactionUsecase get removeReactionUsecase {
    _removeReactionUsecase ??= RemoveReactionUsecase(postRepository);
    return _removeReactionUsecase!;
  }

  /// Get post by ID use case
  GetPostByIdUsecase get getPostByIdUsecase {
    _getPostByIdUsecase ??= GetPostByIdUsecase(postRepository);
    return _getPostByIdUsecase!;
  }

  /// Get reactions use case
  GetReactionsUsecase get getReactionsUsecase {
    _getReactionsUsecase ??= GetReactionsUsecase(postRepository);
    return _getReactionsUsecase!;
  }

  /// Get feeds cubit (singleton)
  FeedsCubit get feedsCubit {
    _feedsCubit ??= FeedsCubit(
      getPostsUsecase,
      createPostUsecase,
      searchUsersUsecase,
      sendFriendRequestUsecase,
      getFriendsUsecase,
      getPendingFriendRequestsUsecase,
      acceptFriendRequestUsecase,
      rejectFriendRequestUsecase,
      removeFriendUsecase,
      deletePostUsecase,
      addReactionUsecase,
      removeReactionUsecase,
      getPostByIdUsecase,
      getReactionsUsecase,
    );
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
    _searchUsersUsecase = null;
    _sendFriendRequestUsecase = null;
    _getFriendsUsecase = null;
    _getPendingFriendRequestsUsecase = null;
    _acceptFriendRequestUsecase = null;
    _rejectFriendRequestUsecase = null;
    _removeFriendUsecase = null;
    _feedsCubit?.dispose();
    _feedsCubit = null;
  }
}
