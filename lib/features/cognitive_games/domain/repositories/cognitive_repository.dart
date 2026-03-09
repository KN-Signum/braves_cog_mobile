import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:dartz/dartz.dart';

abstract class CognitiveRepository {
  Future<Either<Failure, void>> saveTestResult(CognitiveTestResult result);
}
