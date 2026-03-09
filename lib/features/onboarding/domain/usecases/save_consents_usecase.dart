import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';
import 'package:braves_cog/features/onboarding/domain/repositories/onboarding_repository.dart';

class SaveConsentsUseCase implements UseCase<Unit, ConsentsEntity> {
  final OnboardingRepository repository;

  SaveConsentsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ConsentsEntity params) async {
    return await repository.saveConsents(params);
  }
}
