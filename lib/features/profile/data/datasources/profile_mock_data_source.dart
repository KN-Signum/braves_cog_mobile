import 'package:braves_cog/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:braves_cog/features/profile/data/models/user_profile_model.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

class ProfileMockDataSource implements ProfileRemoteDataSource {
  @override
  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return const UserProfileModel(
      birthYear: '1990',
      height: '175',
      weight: '70',
      currentIllness: 'None',
      chronicDiseases: 'Hypertension',
      smokingCigarettes: false,
      smokingFrequency: '',
      drinkingAlcohol: true,
      alcoholFrequency: 'Occasionally',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: ['Peanuts', 'Penicillin'],
      medications: ['Lisinopril'],
      biologicalSex: 'male',
      genderIdentity: 'male',
      genderIdentityOther: '',
      education: 'higher',
      educationOther: '',
      disability: 'none',
    );
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    await Future.delayed(const Duration(seconds: 1));
    // Verify successful update
    return;
  }
}
