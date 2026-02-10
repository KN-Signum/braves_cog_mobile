import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/health/data/datasources/health_local_data_source.dart';
import 'package:braves_cog/features/health/data/datasources/health_remote_data_source.dart';
import 'package:braves_cog/features/health/data/models/health_data_model.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/domain/repositories/health_repository.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;
  final HealthLocalDataSource localDataSource;

  HealthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> saveHealthData(HealthDataEntity healthData) async {
    try {
      final model = HealthDataModel.fromEntity(healthData);
      
      // Try to save remotely
      await remoteDataSource.saveHealthData(model);
      
      // Save locally as cache/history
      await localDataSource.cacheHealthData(model);
      
      return const Right(null);
    } catch (e) {
      // If remote fails, we might still want to report success if local worked, 
      // or return failure. For now, strict failure.
      // In a real offline-first app, we'd queue it.
      
      // Fallback: Just save locally if remote fails (Offline support)
      try {
        final model = HealthDataModel.fromEntity(healthData);
        await localDataSource.cacheHealthData(model);
         return const Right(null);
      } catch (localError) {
        return Left(CacheFailure(localError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<HealthDataEntity>>> getHealthHistory() async {
    try {
      final localData = await localDataSource.getCachedHealthHistory();
      return Right(localData);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
