import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';

class HealthDataModel extends HealthDataEntity {
  const HealthDataModel({
    super.doctorVisited,
    super.specialization,
    super.symptoms,
    super.diagnosis,
    super.procedures,
    super.takingMeds,
    super.medsChanged,
    super.medicationNames,
    super.adverseEvents,
    super.adverseEventsOther,
    super.sleepHours,
    super.sleepQuality,
    super.sleepWakings,
    super.activityMinutes,
    super.activityTypes,
    super.nutrition,
    super.nutritionOther,
    super.submittedAt,
  });

  factory HealthDataModel.fromJson(Map<String, dynamic> json) {
    return HealthDataModel(
      doctorVisited: json['doctorVisited'] ?? false,
      specialization: json['specialization'],
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      procedures: json['procedures'],
      takingMeds: json['takingMeds'],
      medsChanged: json['medsChanged'] ?? false,
      medicationNames: List<String>.from(json['medicationNames'] ?? []),
      adverseEvents: List<String>.from(json['adverseEvents'] ?? []),
      adverseEventsOther: List<String>.from(json['adverseEventsOther'] ?? []),
      sleepHours: json['sleepHours'] ?? 0,
      sleepQuality: json['sleepQuality'],
      sleepWakings: json['sleepWakings'] ?? 0,
      activityMinutes: json['activityMinutes'] ?? 0,
      activityTypes: List<String>.from(json['activityTypes'] ?? []),
      nutrition: List<String>.from(json['nutrition'] ?? []),
      nutritionOther: List<String>.from(json['nutritionOther'] ?? []),
      submittedAt: json['submittedAt'] != null 
          ? DateTime.parse(json['submittedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorVisited': doctorVisited,
      'specialization': specialization,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'procedures': procedures,
      'takingMeds': takingMeds,
      'medsChanged': medsChanged,
      'medicationNames': medicationNames,
      'adverseEvents': adverseEvents,
      'adverseEventsOther': adverseEventsOther,
      'sleepHours': sleepHours,
      'sleepQuality': sleepQuality,
      'sleepWakings': sleepWakings,
      'activityMinutes': activityMinutes,
      'activityTypes': activityTypes,
      'nutrition': nutrition,
      'nutritionOther': nutritionOther,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  factory HealthDataModel.fromEntity(HealthDataEntity entity) {
    return HealthDataModel(
      doctorVisited: entity.doctorVisited,
      specialization: entity.specialization,
      symptoms: entity.symptoms,
      diagnosis: entity.diagnosis,
      procedures: entity.procedures,
      takingMeds: entity.takingMeds,
      medsChanged: entity.medsChanged,
      medicationNames: entity.medicationNames,
      adverseEvents: entity.adverseEvents,
      adverseEventsOther: entity.adverseEventsOther,
      sleepHours: entity.sleepHours,
      sleepQuality: entity.sleepQuality,
      sleepWakings: entity.sleepWakings,
      activityMinutes: entity.activityMinutes,
      activityTypes: entity.activityTypes,
      nutrition: entity.nutrition,
      nutritionOther: entity.nutritionOther,
      submittedAt: entity.submittedAt,
    );
  }
}
