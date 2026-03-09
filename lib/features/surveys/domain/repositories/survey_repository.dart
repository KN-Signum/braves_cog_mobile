import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';

abstract class SurveyRepository {
  Future<Either<Failure, void>> saveSurveyResult({
    required SurveySubmissionModel submission,
  });
}
