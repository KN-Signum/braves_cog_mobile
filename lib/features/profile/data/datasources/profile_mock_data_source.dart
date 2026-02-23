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
      userType = UserType.normalCog;
    }

    // Return different profiles based on user type
    return switch (userType) {
      UserType.neuroCog => _buildNeuroCogProfile(),
      UserType.covidCog => _buildCovidCogProfile(),
      UserType.vasCog => _buildVasCogProfile(),
      UserType.sccCog => _buildSccCogProfile(),
      UserType.normalCog => _buildNormalCogProfile(),
    };
  }

  UserType _getUserTypeFromEmail(String email) {
    return switch (email) {
      // New study group emails
      'vascog@test.pl' => UserType.vasCog,
      'neurocog@test.pl' => UserType.neuroCog,
      'covidcog@test.pl' => UserType.covidCog,
      'scccog@test.pl' => UserType.sccCog,
      'normalcog@test.pl' => UserType.normalCog,

      // Backward-compatible aliases
      'hypertension@test.pl' => UserType.vasCog,
      'adhd@test.pl' => UserType.neuroCog,
      'covid@test.pl' => UserType.covidCog,
      'scc@test.pl' => UserType.sccCog,
      'normal@test.pl' => UserType.normalCog,

      _ => UserType.normalCog,
    };
  }

  UserProfileModel _buildNeuroCogProfile() {
    return const UserProfileModel(
      id: 'neurocog_user',
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
      type: UserType.neuroCog,
    );
  }

  UserProfileModel _buildCovidCogProfile() {
    return const UserProfileModel(
      id: 'covidcog_user',
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
      type: UserType.covidCog,
    );
  }

  UserProfileModel _buildVasCogProfile() {
    return const UserProfileModel(
      id: 'vascog_user',
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
      type: UserType.vasCog,
    );
  }

  UserProfileModel _buildSccCogProfile() {
    return const UserProfileModel(
      id: 'scccog_user',
      birthYear: '1992',
      height: '172',
      weight: '68',
      currentIllness: 'None',
      chronicDiseases: 'None',
      smokingCigarettes: false,
      smokingFrequency: '',
      drinkingAlcohol: true,
      alcoholFrequency: 'Occasionally',
      otherSubstances: false,
      otherSubstancesName: '',
      otherSubstancesFrequency: '',
      allergies: [],
      medications: [],
      biologicalSex: 'female',
      genderIdentity: 'female',
      genderIdentityOther: '',
      education: 'higher',
      educationOther: '',
      disability: 'none',
      type: UserType.sccCog,
    );
  }

  UserProfileModel _buildNormalCogProfile() {
    return const UserProfileModel(
      id: 'normalcog_user',
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
      type: UserType.normalCog,
    );
  }

  @override
  Future<void> updateUserProfile(UserProfileEntity profile) async {
    await Future.delayed(const Duration(seconds: 1));
    // Verify successful update
    return;
  }
}
