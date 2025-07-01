import '../models/profile_user.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting current user profile
class GetCurrentProfileUseCase {
  final ProfileRepository _repository;

  GetCurrentProfileUseCase(this._repository);

  Future<ProfileUser?> call() async {
    try {
      // First try to get from remote API
      final profile = await _repository.getCurrentProfile();

      if (profile != null) {
        // Cache the fresh data
        await _repository.cacheProfile(profile);
        return profile;
      }

      // Fallback to cached data
      final cachedProfile = await _repository.getCachedProfile();
      return cachedProfile;
    } catch (e) {
      // If remote fails, try cached data
      final cachedProfile = await _repository.getCachedProfile();
      return cachedProfile;
    }
  }
}
