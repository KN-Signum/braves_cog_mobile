import 'package:equatable/equatable.dart';
import 'survey_question_entity.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String title;
  final List<SurveyQuestionEntity> questions;

  const SurveyEntity({
    required this.id,
    required this.title,
    required this.questions,
  });

  @override
  List<Object?> get props => [id, title, questions];
}



