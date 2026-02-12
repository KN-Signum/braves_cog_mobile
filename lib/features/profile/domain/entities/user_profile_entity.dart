import 'package:equatable/equatable.dart';
import 'user_type.dart';

class UserProfileEntity extends Equatable {
  final String birthYear;
  final String height;
  final String weight;
  final String currentIllness;
  final String chronicDiseases;
  final bool smokingCigarettes;
  final String smokingFrequency;
  final bool drinkingAlcohol;
  final String alcoholFrequency;
  final bool otherSubstances;
  final String otherSubstancesName;
  final String otherSubstancesFrequency;
  final List<String> allergies;
  final List<String> medications;
  final String biologicalSex;
  final String genderIdentity;
  final String genderIdentityOther;
  final String education;
  final String educationOther;
  final String disability;
  final UserType type;

  const UserProfileEntity({
    this.birthYear = '1990',
    this.height = '170',
    this.weight = '70',
    this.currentIllness = '',
    this.chronicDiseases = '',
    this.smokingCigarettes = false,
    this.smokingFrequency = '',
    this.drinkingAlcohol = false,
    this.alcoholFrequency = '',
    this.otherSubstances = false,
    this.otherSubstancesName = '',
    this.otherSubstancesFrequency = '',
    this.allergies = const [],
    this.medications = const [],
    this.biologicalSex = '',
    this.genderIdentity = '',
    this.genderIdentityOther = '',
    this.education = '',
    this.educationOther = '',
    this.disability = '',
    this.type = UserType.normal,
  });

  UserProfileEntity copyWith({
    String? birthYear,
    String? height,
    String? weight,
    String? currentIllness,
    String? chronicDiseases,
    bool? smokingCigarettes,
    String? smokingFrequency,
    bool? drinkingAlcohol,
    String? alcoholFrequency,
    bool? otherSubstances,
    String? otherSubstancesName,
    String? otherSubstancesFrequency,
    List<String>? allergies,
    List<String>? medications,
    String? biologicalSex,
    String? genderIdentity,
    String? genderIdentityOther,
    String? education,
    String? educationOther,
    String? disability,
    UserType? type,
  }) {
    return UserProfileEntity(
      birthYear: birthYear ?? this.birthYear,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      currentIllness: currentIllness ?? this.currentIllness,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      smokingCigarettes: smokingCigarettes ?? this.smokingCigarettes,
      smokingFrequency: smokingFrequency ?? this.smokingFrequency,
      drinkingAlcohol: drinkingAlcohol ?? this.drinkingAlcohol,
      alcoholFrequency: alcoholFrequency ?? this.alcoholFrequency,
      otherSubstances: otherSubstances ?? this.otherSubstances,
      otherSubstancesName: otherSubstancesName ?? this.otherSubstancesName,
      otherSubstancesFrequency:
          otherSubstancesFrequency ?? this.otherSubstancesFrequency,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      genderIdentityOther: genderIdentityOther ?? this.genderIdentityOther,
      education: education ?? this.education,
      educationOther: educationOther ?? this.educationOther,
      disability: disability ?? this.disability,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
    birthYear,
    height,
    weight,
    currentIllness,
    chronicDiseases,
    smokingCigarettes,
    smokingFrequency,
    drinkingAlcohol,
    alcoholFrequency,
    otherSubstances,
    otherSubstancesName,
    otherSubstancesFrequency,
    allergies,
    medications,
    biologicalSex,
    genderIdentity,
    genderIdentityOther,
    education,
    educationOther,
    disability,
    type,
  ];
}
