import '../models/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting current user profile
class GetCurrentProfileUseCase {
  final ProfileRepository _repository;

  GetCurrentProfileUseCase(this._repository);
  Future<ProfileUser?> call() async {
    try {
      print(
        'GetCurrentProfileUseCase: Trying to get profile from remote API...',
      );
      // First try to get from remote API
      final profile = await _repository.getCurrentProfile();

      if (profile != null) {
        print(
          'GetCurrentProfileUseCase: Profile loaded from remote: ${profile.username}',
        );
        // Cache the fresh data
        await _repository.cacheProfile(profile);
        return profile;
      }

      print(
        'GetCurrentProfileUseCase: Remote profile is null, trying cached data...',
      );
      // Fallback to cached data
      final cachedProfile = await _repository.getCachedProfile();
      print(
        'GetCurrentProfileUseCase: Cached profile: ${cachedProfile != null ? 'Found' : 'Not found'}',
      );
      return cachedProfile;
    } catch (e) {
      print('GetCurrentProfileUseCase: Error occurred: $e');
      // If remote fails, try cached data
      final cachedProfile = await _repository.getCachedProfile();
      print(
        'GetCurrentProfileUseCase: Fallback cached profile: ${cachedProfile != null ? 'Found' : 'Not found'}',
      );
      return cachedProfile;
    }
  }
}
