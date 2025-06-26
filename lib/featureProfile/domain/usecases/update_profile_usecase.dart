import '../models/profile_request.dart';
import '../repositories/profile_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<bool> call(String userId, UpdateProfileRequest request) async {
    try {
      final success = await _repository.updateProfile(userId, request);

      if (success) {
        // Refresh the profile data after successful update
        final updatedProfile = await _repository.getUserProfile(userId);
        if (updatedProfile != null) {
          await _repository.cacheProfile(updatedProfile);
        }
      }

      return success;
    } catch (e) {
      return false;
    }
  }
}
