import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/surveys/domain/repositories/survey_repository.dart';
import 'package:braves_cog/features/surveys/domain/entities/survey_submission_model.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_local_data_source.dart';
import 'package:braves_cog/features/surveys/data/datasources/survey_remote_data_source.dart';
import 'package:flutter/foundation.dart';

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
      debugPrint(
        '[SurveyRepository] Saving survey: ${submission.surveyId} score=${submission.score}',
      );

      try {
        await localDataSource.cacheSurveyAnswers(
          submission.surveyId,
          submission.answersMap,
        );
        debugPrint(
          '[SurveyRepository] Local cache saved for: ${submission.surveyId}',
        );
      } catch (cacheError) {
        debugPrint('[SurveyRepository] Cache error: $cacheError');
        return Left(CacheFailure('Błąd zapisu lokalnej ankiety: $cacheError'));
      }

      try {
        await remoteDataSource.submitSurveyAnswers(submission: submission);
        debugPrint(
          '[SurveyRepository] Remote submission success: ${submission.surveyId}',
        );
      } catch (remoteError) {
        debugPrint('[SurveyRepository] Remote submission failed: $remoteError');
        return Left(
          ServerFailure('Błąd wysyłania ankiety do serwera: $remoteError'),
        );
      }

      return const Right(null);
    } catch (e) {
      debugPrint('[SurveyRepository] Unexpected error: $e');
      return Left(ServerFailure('Błąd wysyłania ankiety do serwera: $e'));
    }
  }
}
