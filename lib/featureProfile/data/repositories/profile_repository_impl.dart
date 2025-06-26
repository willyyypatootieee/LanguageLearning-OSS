import '../../domain/models/profile_user.dart';
import '../../domain/models/profile_request.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../featureAuthentication/domain/repositories/auth_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final AuthRepository _authRepository;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._authRepository,
  );  @override
  Future<ProfileUser?> getCurrentProfile() async {
    try {
      print('ProfileRepository: Getting current user from auth...');
      // Get current user from auth
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        print('ProfileRepository: Current user is null');
        return null;
      }
      print(
        'ProfileRepository: Current user: ${currentUser.username} (ID: ${currentUser.id})',
      );

      // First, create a basic profile from the auth user
      final basicProfile = ProfileUser.fromAuthUser(currentUser);
      print('ProfileRepository: Created basic profile from auth user');

      // Try to get extended data from API
      try {
        final token = await _authRepository.getToken();
        if (token != null) {
          print('ProfileRepository: Token obtained (length: ${token.length})');
          print('ProfileRepository: Fetching extended profile from API...');
          final extendedProfile = await _remoteDataSource.getUserProfile(
            currentUser.id,
            token,
          );
          
          if (extendedProfile != null) {
            print('ProfileRepository: Extended profile loaded successfully');
            return extendedProfile;
          } else {
            print('ProfileRepository: API returned null, using basic profile');
          }
        } else {
          print('ProfileRepository: No token available, using basic profile');
        }
      } catch (e) {
        print('ProfileRepository: API call failed: $e, using basic profile');
      }

      // Return basic profile as fallback
      return basicProfile;
    } catch (e) {
      print('ProfileRepository: Error in getCurrentProfile: $e');
      return null;
    }
  }

  @override
  Future<ProfileUser?> getUserProfile(String userId) async {
    try {
      // Get token
      final token = await _authRepository.getToken();
      if (token == null) return null;

      // Fetch profile from API
      return await _remoteDataSource.getUserProfile(userId, token);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateProfile(
    String userId,
    UpdateProfileRequest request,
  ) async {
    try {
      // Get token
      final token = await _authRepository.getToken();
      if (token == null) return false;

      // Update profile via API
      return await _remoteDataSource.updateProfile(userId, token, request);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ProfileUser?> getCachedProfile() async {
    return await _localDataSource.getCachedProfile();
  }

  @override
  Future<void> cacheProfile(ProfileUser profile) async {
    await _localDataSource.cacheProfile(profile);
  }

  @override
  Future<bool> hasLocalProfile() async {
    return await _localDataSource.hasCache();
  }

  @override
  Future<void> clearLocalProfile() async {
    await _localDataSource.clearCache();
  }
}
