import 'package:equatable/equatable.dart';

class SurveySubmissionModel extends Equatable {
  final String surveyId;
  final String userId;
  final Map<String, dynamic> metadata;
  final List<SurveyAnswerModel> answers;

  const SurveySubmissionModel({
    required this.surveyId,
    required this.userId,
    required this.metadata,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'surveyId': surveyId,
      'userId': userId,
      'metadata': metadata,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory SurveySubmissionModel.fromJson(Map<String, dynamic> json) {
    return SurveySubmissionModel(
      surveyId: json['surveyId'] as String,
      userId: json['userId'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map(
                (a) => SurveyAnswerModel.fromJson(a as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [surveyId, userId, metadata, answers];
}

class SurveyAnswerModel extends Equatable {
  final String questionId;
  final String type;
  final dynamic value;

  const SurveyAnswerModel({
    required this.questionId,
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'type': type, 'value': value};
  }

  factory SurveyAnswerModel.fromJson(Map<String, dynamic> json) {
    return SurveyAnswerModel(
      questionId: json['questionId'] as String,
      type: json['type'] as String,
      value: json['value'],
    );
  }

  @override
  List<Object?> get props => [questionId, type, value];
}
