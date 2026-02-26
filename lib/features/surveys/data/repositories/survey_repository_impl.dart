import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/surveys/domain/repositories/survey_repository.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_local_data_source.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_remote_data_source.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyRemoteDataSource remoteDataSource;
  final SurveyLocalDataSource localDataSource;

  SurveyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> saveSurveyResult({
    required SurveySubmissionModel submission,
  }) async {
    try {
      await remoteDataSource.submitSurveyAnswers(submission: submission);

      // Convert answers back to Map for local cache if needed
      final answersMap = {
        for (var a in submission.answers) a.questionId: a.value,
      };
      // Optionally cache locally if successful
      await localDataSource.cacheSurveyAnswers(submission.surveyId, answersMap);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
