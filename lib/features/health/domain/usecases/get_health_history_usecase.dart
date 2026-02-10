import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/health/domain/entities/health_data_entity.dart';
import 'package:braves_cog/features/health/domain/repositories/health_repository.dart';

class GetHealthHistoryUseCase implements UseCase<List<HealthDataEntity>, NoParams> {
  final HealthRepository repository;

  GetHealthHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<HealthDataEntity>>> call(NoParams params) async {
    return await repository.getHealthHistory();
  }
}
