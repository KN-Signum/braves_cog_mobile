import 'package:equatable/equatable.dart';

enum QuestionType {
  text,
  number,
  choice,
  multichoice,
  table,
  time,
  slider,
  date,
  boolean,
}

class SurveyQuestionEntity extends Equatable {
  final String id;
  final QuestionType type;
  final String question;
  final String? description;
  final bool required;
  final Map<String, dynamic>? options;
  final Map<String, dynamic>? validation;
  final Map<String, dynamic>? conditionalLogic;
  final String? genderForm;

  const SurveyQuestionEntity({
    required this.id,
    required this.type,
    required this.question,
    this.description,
    this.required = false,
    this.options,
    this.validation,
    this.conditionalLogic,
    this.genderForm,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        question,
        description,
        required,
        options,
        validation,
        conditionalLogic,
        genderForm,
      ];
}



