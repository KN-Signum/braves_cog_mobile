import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';
import 'package:braves_cog/features/profile/domain/entities/biological_sex.dart';
import 'package:braves_cog/features/profile/domain/entities/education_level.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    super.id,
    super.birthYear,
    super.height,
    super.weight,
    super.currentIllness,
    super.chronicDiseases,
    super.smokingCigarettes,
    super.smokingFrequency,
    super.drinkingAlcohol,
    super.alcoholFrequency,
    super.otherSubstances,
    super.otherSubstancesName,
    super.otherSubstancesFrequency,
    super.allergies,
    super.medications,
    super.biologicalSex,
    super.genderIdentity,
    super.genderIdentityOther,
    super.education,
    super.educationOther,
    super.disability,
    super.type,
  });

  /// Factory constructor to handle both camelCase (API) and snake_case (Database) JSON
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Support both camelCase (from API) and snake_case (from database)
    final birthYear = json['birthYear'] ?? json['birth_year'];
    final height = json['height'] ?? json['height'];
    final weight = json['weight'] ?? json['weight'];
    final currentIllness = json['currentIllness'] ?? json['current_illness'];
    final chronicDiseases = json['chronicDiseases'] ?? json['chronic_diseases'];
    final smokingCigarettes =
        json['smokingCigarettes'] ?? json['smoking_cigarettes'];
    final smokingFrequency =
        json['smokingFrequency'] ?? json['smoking_frequency'];
    final drinkingAlcohol = json['drinkingAlcohol'] ?? json['drinking_alcohol'];
    final alcoholFrequency =
        json['alcoholFrequency'] ?? json['alcohol_frequency'];
    final otherSubstances = json['otherSubstances'] ?? json['other_substances'];
    final otherSubstancesName =
        json['otherSubstancesName'] ?? json['other_substances_name'];
    final otherSubstancesFrequency =
        json['otherSubstancesFrequency'] ?? json['other_substances_frequency'];
    final allergies = json['allergies'] ?? [];
    final medications = json['medications'] ?? [];
    final biologicalSexVal = json['biologicalSex'] ?? json['biological_sex'];
    final genderIdentity = json['genderIdentity'] ?? json['gender_identity'];
    final genderIdentityOther =
        json['genderIdentityOther'] ?? json['gender_identity_other'];
    final educationVal = json['education'] ?? json['education'];
    final educationOther = json['educationOther'] ?? json['education_other'];
    final disability = json['disability'] ?? json['disability'];
    final typeVal = json['type'] ?? json['type'];

    return UserProfileModel(
      id: json['id'],
      birthYear: birthYear is int
          ? birthYear
          : int.tryParse(birthYear?.toString() ?? '') ?? 1990,
      height: height is int
          ? height
          : int.tryParse(height?.toString() ?? '') ?? 170,
      weight: weight is int
          ? weight
          : int.tryParse(weight?.toString() ?? '') ?? 70,
      currentIllness: currentIllness ?? '',
      chronicDiseases: chronicDiseases ?? '',
      smokingCigarettes: smokingCigarettes ?? false,
      smokingFrequency: smokingFrequency ?? '',
      drinkingAlcohol: drinkingAlcohol ?? false,
      alcoholFrequency: alcoholFrequency ?? '',
      otherSubstances: otherSubstances ?? false,
      otherSubstancesName: otherSubstancesName ?? '',
      otherSubstancesFrequency: otherSubstancesFrequency ?? '',
      allergies: List<String>.from(allergies ?? []),
      medications: List<String>.from(medications ?? []),
      biologicalSex: BiologicalSex.fromString(biologicalSexVal ?? ''),
      genderIdentity: genderIdentity ?? '',
      genderIdentityOther: genderIdentityOther ?? '',
      education: EducationLevel.fromString(educationVal ?? ''),
      educationOther: educationOther ?? '',
      disability: disability ?? '',
      type: UserType.fromString(typeVal ?? 'NormalCog'),
    );
  }

  /// Convert to camelCase JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'birthYear': birthYear,
      'height': height,
      'weight': weight,
      'currentIllness': currentIllness,
      'chronicDiseases': chronicDiseases,
      'smokingCigarettes': smokingCigarettes,
      'smokingFrequency': smokingFrequency,
      'drinkingAlcohol': drinkingAlcohol,
      'alcoholFrequency': alcoholFrequency,
      'otherSubstances': otherSubstances,
      'otherSubstancesName': otherSubstancesName,
      'otherSubstancesFrequency': otherSubstancesFrequency,
      'allergies': allergies,
      'medications': medications,
      'biologicalSex': biologicalSex.value,
      'genderIdentity': genderIdentity,
      'genderIdentityOther': genderIdentityOther,
      'education': education.value,
      'educationOther': educationOther,
      'disability': disability,
      'type': type.value,
    };
  }
}
