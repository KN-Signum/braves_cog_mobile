import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:dartz/dartz.dart';
import '../repositories/cognitive_repository.dart';

class SaveTestResultUseCase {
  final CognitiveRepository _repository;

  SaveTestResultUseCase(this._repository);

  Future<Either<Failure, void>> call(CognitiveTestResult result) async {
    return await _repository.saveTestResult(result);
  }
}
