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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      birthYear: json['birthYear'] is int
          ? json['birthYear']
          : int.tryParse(json['birthYear']?.toString() ?? '') ?? 1990,
      height: json['height'] is int
          ? json['height']
          : int.tryParse(json['height']?.toString() ?? '') ?? 170,
      weight: json['weight'] is int
          ? json['weight']
          : int.tryParse(json['weight']?.toString() ?? '') ?? 70,
      currentIllness: json['currentIllness'] ?? '',
      chronicDiseases: json['chronicDiseases'] ?? '',
      smokingCigarettes: json['smokingCigarettes'] ?? false,
      smokingFrequency: json['smokingFrequency'] ?? '',
      drinkingAlcohol: json['drinkingAlcohol'] ?? false,
      alcoholFrequency: json['alcoholFrequency'] ?? '',
      otherSubstances: json['otherSubstances'] ?? false,
      otherSubstancesName: json['otherSubstancesName'] ?? '',
      otherSubstancesFrequency: json['otherSubstancesFrequency'] ?? '',
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      biologicalSex: BiologicalSex.fromString(json['biologicalSex'] ?? ''),
      genderIdentity: json['genderIdentity'] ?? '',
      genderIdentityOther: json['genderIdentityOther'] ?? '',
      education: EducationLevel.fromString(json['education'] ?? ''),
      educationOther: json['educationOther'] ?? '',
      disability: json['disability'] ?? '',
      type: UserType.fromString(json['type'] ?? 'NormalCog'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // NOTE: 'id' and 'lastUpdate' omitted. 'id' is extracted from token.
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
