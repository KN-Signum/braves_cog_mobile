import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/surveys/domain/repositories/survey_repository.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';

class SaveSurveyResultUseCase implements UseCase<void, SaveSurveyResultParams> {
  final SurveyRepository repository;

  SaveSurveyResultUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveSurveyResultParams params) async {
    return await repository.saveSurveyResult(submission: params.submission);
  }
}

class SaveSurveyResultParams {
  final SurveySubmissionModel submission;

  SaveSurveyResultParams({required this.submission});
}
