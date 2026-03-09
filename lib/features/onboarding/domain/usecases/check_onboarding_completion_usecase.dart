import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckOnboardingCompletionUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository repository;

  CheckOnboardingCompletionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isOnboardingCompleted();
  }
}
