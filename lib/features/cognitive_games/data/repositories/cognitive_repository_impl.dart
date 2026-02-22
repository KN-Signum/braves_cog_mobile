import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/cognitive_games/data/datasources/cognitive_game_local_data_source.dart';
import 'package:braves_cog/features/cognitive_games/data/datasources/cognitive_game_remote_data_source.dart';
import 'package:braves_cog/features/cognitive_games/data/mappers/rp_result_mapper.dart';
import 'package:braves_cog/features/cognitive_games/domain/entities/cognitive_game_result.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/cognitive_repository.dart';

class CognitiveRepositoryImpl implements CognitiveRepository {
  final CognitiveLocalDataSource localDataSource;
  final CognitiveRemoteDataSource remoteDataSource;

  CognitiveRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, void>> saveTestResult(
    CognitiveTestResult result,
  ) async {
    try {
      final payload = {
        'id': result.id,
        'userId': result.userId,
        'testType': result.testType.name,
        'completedAt': result.completedAt.toIso8601String(),
        'metrics': RPResultMapper.metricsToJson(result.metrics),
        'rawData': result.rawData,
      };

      try {
        await localDataSource.cacheTestResult(payload);
      } catch (cacheError) {
        return Left(
          CacheFailure('Błąd zapisu na dysku urządzenia: $cacheError'),
        );
      }

      await remoteDataSource.saveTestResult(payload);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Błąd połączenia z serwerem BRAVES-Cog: $e'));
    }
  }
}
