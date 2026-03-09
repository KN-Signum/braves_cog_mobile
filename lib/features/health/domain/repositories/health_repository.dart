import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';

abstract class HealthRepository {
  Future<Either<Failure, void>> saveHealthData(HealthDataEntity healthData);
  Future<Either<Failure, List<HealthDataEntity>>> getHealthHistory();
}
