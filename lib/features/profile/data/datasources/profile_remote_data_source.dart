import 'package:braves_cog/features/profile/data/models/user_profile_model.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateUserProfile(UserProfileEntity profile);
}
