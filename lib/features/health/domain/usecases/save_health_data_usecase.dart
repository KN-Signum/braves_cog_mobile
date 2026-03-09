import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/domain/repositories/health_repository.dart';

class SaveHealthDataUseCase implements UseCase<void, HealthDataEntity> {
  final HealthRepository repository;

  SaveHealthDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(HealthDataEntity params) async {
    return await repository.saveHealthData(params);
  }
}
