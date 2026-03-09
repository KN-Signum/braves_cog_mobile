import 'package:equatable/equatable.dart';

class HealthDataEntity extends Equatable {
  final bool doctorVisited;
  final String? specialization;
  final String? symptoms;
  final String? diagnosis;
  final String? procedures;
  final String? takingMeds;
  final bool medsChanged;
  final List<String> medicationNames;
  final List<String> adverseEvents;
  final List<String> adverseEventsOther;
  final int sleepHours;
  final String? sleepQuality;
  final int sleepWakings;
  final int activityMinutes;
  final List<String> activityTypes;
  final List<String> nutrition;
  final List<String> nutritionOther;
  final DateTime? submittedAt;

  const HealthDataEntity({
    this.doctorVisited = false,
    this.specialization,
    this.symptoms,
    this.diagnosis,
    this.procedures,
    this.takingMeds,
    this.medsChanged = false,
    this.medicationNames = const [],
    this.adverseEvents = const [],
    this.adverseEventsOther = const [],
    this.sleepHours = 0,
    this.sleepQuality,
    this.sleepWakings = 0,
    this.activityMinutes = 0,
    this.activityTypes = const [],
    this.nutrition = const [],
    this.nutritionOther = const [],
    this.submittedAt,
  });

  HealthDataEntity copyWith({
    bool? doctorVisited,
    String? specialization,
    String? symptoms,
    String? diagnosis,
    String? procedures,
    String? takingMeds,
    bool? medsChanged,
    List<String>? medicationNames,
    List<String>? adverseEvents,
    List<String>? adverseEventsOther,
    int? sleepHours,
    String? sleepQuality,
    int? sleepWakings,
    int? activityMinutes,
    List<String>? activityTypes,
    List<String>? nutrition,
    List<String>? nutritionOther,
    DateTime? submittedAt,
  }) {
    return HealthDataEntity(
      doctorVisited: doctorVisited ?? this.doctorVisited,
      specialization: specialization ?? this.specialization,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      procedures: procedures ?? this.procedures,
      takingMeds: takingMeds ?? this.takingMeds,
      medsChanged: medsChanged ?? this.medsChanged,
      medicationNames: medicationNames ?? this.medicationNames,
      adverseEvents: adverseEvents ?? this.adverseEvents,
      adverseEventsOther: adverseEventsOther ?? this.adverseEventsOther,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sleepWakings: sleepWakings ?? this.sleepWakings,
      activityMinutes: activityMinutes ?? this.activityMinutes,
      activityTypes: activityTypes ?? this.activityTypes,
      nutrition: nutrition ?? this.nutrition,
      nutritionOther: nutritionOther ?? this.nutritionOther,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  @override
  List<Object?> get props => [
        doctorVisited,
        specialization,
        symptoms,
        diagnosis,
        procedures,
        takingMeds,
        medsChanged,
        medicationNames,
        adverseEvents,
        adverseEventsOther,
        sleepHours,
        sleepQuality,
        sleepWakings,
        activityMinutes,
        activityTypes,
        nutrition,
        nutritionOther,
        submittedAt,
      ];
}
