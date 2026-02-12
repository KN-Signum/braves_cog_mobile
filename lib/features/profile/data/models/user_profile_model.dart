import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/entities/user_type.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
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
      birthYear: json['birthYear'] ?? '1990',
      height: json['height'] ?? '170',
      weight: json['weight'] ?? '70',
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
      biologicalSex: json['biologicalSex'] ?? '',
      genderIdentity: json['genderIdentity'] ?? '',
      genderIdentityOther: json['genderIdentityOther'] ?? '',
      education: json['education'] ?? '',
      educationOther: json['educationOther'] ?? '',
      disability: json['disability'] ?? '',
      type: UserType.fromString(json['type'] ?? 'NORMAL'),
    );
  }

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
      'biologicalSex': biologicalSex,
      'genderIdentity': genderIdentity,
      'genderIdentityOther': genderIdentityOther,
      'education': education,
      'educationOther': educationOther,
      'disability': disability,
      'type': type.value,
      'lastUpdate': DateTime.now().toIso8601String(),
    };
  }
}
