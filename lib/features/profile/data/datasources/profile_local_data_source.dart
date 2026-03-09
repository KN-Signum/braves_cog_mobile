import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/features/profile/data/models/user_profile_model.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getLastUserProfile({String? email});
  Future<void> cacheUserProfile(UserProfileEntity profile, {String? email});
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl(this.sharedPreferences);

  static const cachedProfileKey = 'user-profile';
  static const cachedProfileEmailKey = 'user-profile-email';

  @override
  Future<UserProfileModel?> getLastUserProfile({String? email}) async {
    // If email is provided, only return cache if it belongs to the same user
    if (email != null) {
      final cachedEmail = sharedPreferences.getString(cachedProfileEmailKey);
      if (cachedEmail != null && cachedEmail != email) {
        return null;
      }
    }

    final jsonString = sharedPreferences.getString(cachedProfileKey);
    if (jsonString != null) {
      return UserProfileModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUserProfile(UserProfileEntity profile, {String? email}) async {
    // Convert entity to model to access toJson
    final model = UserProfileModel(
      birthYear: profile.birthYear,
      height: profile.height,
      weight: profile.weight,
      currentIllness: profile.currentIllness,
      chronicDiseases: profile.chronicDiseases,
      smokingCigarettes: profile.smokingCigarettes,
      smokingFrequency: profile.smokingFrequency,
      drinkingAlcohol: profile.drinkingAlcohol,
      alcoholFrequency: profile.alcoholFrequency,
      otherSubstances: profile.otherSubstances,
      otherSubstancesName: profile.otherSubstancesName,
      otherSubstancesFrequency: profile.otherSubstancesFrequency,
      allergies: profile.allergies,
      medications: profile.medications,
      biologicalSex: profile.biologicalSex,
      genderIdentity: profile.genderIdentity,
      genderIdentityOther: profile.genderIdentityOther,
      education: profile.education,
      educationOther: profile.educationOther,
      disability: profile.disability,
      type: profile.type,
    );
    
    if (email != null) {
      await sharedPreferences.setString(cachedProfileEmailKey, email);
    }

    await sharedPreferences.setString(
      cachedProfileKey,
      json.encode(model.toJson()),
    );
  }
}
