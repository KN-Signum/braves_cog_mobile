import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> saveConsents(ConsentsEntity consents);
  Future<Either<Failure, Unit>> completeOnboarding();
  Future<Either<Failure, bool>> isOnboardingCompleted();
}
