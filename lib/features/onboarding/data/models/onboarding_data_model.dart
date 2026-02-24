import 'dart:convert';

class OnboardingDataModel {
  final Map<String, dynamic> demographic;
  final Map<String, dynamic> baselineLifestyle;
  final Map<String, dynamic> baselineSymptoms;
  final Map<String, dynamic> baselineMedicalHistory;
  final DateTime completedAt;

  OnboardingDataModel({
    required this.demographic,
    required this.baselineLifestyle,
    required this.baselineSymptoms,
    required this.baselineMedicalHistory,
    required this.completedAt,
  });

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return OnboardingDataModel(
      demographic: json['Demographic'] as Map<String, dynamic>? ?? {},
      baselineLifestyle: json['Baseline_Lifestyle'] as Map<String, dynamic>? ?? {},
      baselineSymptoms: json['Baseline_Symptoms'] as Map<String, dynamic>? ?? {},
      baselineMedicalHistory: json['Baseline_Medical_History'] as Map<String, dynamic>? ?? {},
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Demographic': demographic,
      'Baseline_Lifestyle': baselineLifestyle,
      'Baseline_Symptoms': baselineSymptoms,
      'Baseline_Medical_History': baselineMedicalHistory,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  factory OnboardingDataModel.fromJsonString(String jsonString) {
    return OnboardingDataModel.fromJson(json.decode(jsonString));
  }
}

















