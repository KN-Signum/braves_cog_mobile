import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';

abstract class SurveyRemoteDataSource {
  Future<void> submitSurveyAnswers({required SurveySubmissionModel submission});
}
