import 'package:braves_cog/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:braves_cog/features/profile/data/models/user_profile_model.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

class ProfileMockDataSource implements ProfileRemoteDataSource {
  @override
  Future<UserProfileModel> getUserProfile({String? email}) async {
    await Future.delayed(const Duration(seconds: 1));

    // Determine user type based on email
    late UserType userType;
    if (email != null) {
      userType = _getUserTypeFromEmail(email);
    } else {
      userType = UserType.normal;
    }

    // Return different profiles based on user type
    return switch (userType) {
      UserType.adhd => _buildADHDProfile(),
      UserType.covid => _buildCOVIDProfile(),
      UserType.hypertension => _buildHypertensionProfile(),
      UserType.normal => _buildNormalProfile(),
    };
  }

  UserType _getUserTypeFromEmail(String email) {
    return switch (email) {
      'adhd@test.pl' => UserType.adhd,
      'covid@test.pl' => UserType.covid,
      'hypertension@test.pl' => UserType.hypertension,
      _ => UserType.normal,
    };
  }

  UserProfileModel _buildADHDProfile() {
    return const UserProfileModel(
      birthYear: '1995',
      height: '175',
      weight: '70',
      currentIllness: 'None',
      chronicDiseases: 'ADHD',
      smokingCigarettes: false,
      smokingFrequency: '',
      drinkingAlcohol: false,
      alcoholFrequency: '',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: [],
      medications: ['Methylphenidate'],
      biologicalSex: 'male',
      genderIdentity: 'male',
      genderIdentityOther: '',
      education: 'higher',
      educationOther: '',
      disability: 'none',
      type: UserType.adhd,
    );
  }

  UserProfileModel _buildCOVIDProfile() {
    return const UserProfileModel(
      birthYear: '1988',
      height: '170',
      weight: '75',
      currentIllness: 'COVID-19 recovery',
      chronicDiseases: 'None',
      smokingCigarettes: false,
      smokingFrequency: '',
      drinkingAlcohol: true,
      alcoholFrequency: 'Rarely',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: ['Aspirin'],
      medications: [],
      biologicalSex: 'female',
      genderIdentity: 'female',
      genderIdentityOther: '',
      education: 'higher',
      educationOther: '',
      disability: 'none',
      type: UserType.covid,
    );
  }

  UserProfileModel _buildHypertensionProfile() {
    return const UserProfileModel(
      birthYear: '1965',
      height: '180',
      weight: '85',
      currentIllness: 'None',
      chronicDiseases: 'Hypertension',
      smokingCigarettes: true,
      smokingFrequency: 'Daily',
      drinkingAlcohol: true,
      alcoholFrequency: 'Often',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: ['Lisinopril alternatives'],
      medications: ['Lisinopril', 'Amlodipine'],
      biologicalSex: 'male',
      genderIdentity: 'male',
      genderIdentityOther: '',
      education: 'secondary',
      educationOther: '',
      disability: 'none',
      type: UserType.hypertension,
    );
  }

  UserProfileModel _buildNormalProfile() {
    return const UserProfileModel(
      birthYear: '1990',
      height: '175',
      weight: '70',
      currentIllness: 'None',
      chronicDiseases: 'None',
      smokingCigarettes: false,
      smokingFrequency: '',
      drinkingAlcohol: true,
      alcoholFrequency: 'Occasionally',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: ['Peanuts'],
      medications: [],
      biologicalSex: 'male',
      genderIdentity: 'male',
      genderIdentityOther: '',
      education: 'higher',
      educationOther: '',
      disability: 'none',
      type: UserType.normal,
    );
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    await Future.delayed(const Duration(seconds: 1));
    // Verify successful update
    return;
  }
}
