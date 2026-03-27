import 'package:equatable/equatable.dart';

class SurveySubmissionModel extends Equatable {
  final String surveyId;
  final String userId;
  final Map<String, dynamic> answersMap;
  final int? score;
  final Map<String, dynamic> metadata;

  const SurveySubmissionModel({
    required this.surveyId,
    required this.userId,
    required this.answersMap,
    this.score,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyId': surveyId,
      'userId': userId,
      'answersMap': answersMap,
      'score': score,
      'metadata': metadata,
    };
  }

  factory SurveySubmissionModel.fromJson(Map<String, dynamic> json) {
    return SurveySubmissionModel(
      surveyId: json['surveyId'] as String,
      userId: json['userId'] as String,
      answersMap: json['answersMap'] as Map<String, dynamic>? ?? {},
      score: json['score'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  List<Object?> get props => [surveyId, userId, answersMap, score, metadata];
}
