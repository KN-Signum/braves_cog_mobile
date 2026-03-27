import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Activate a new user account with invite code and password
  ///
  /// This implements the invite-only activation flow:
  /// 1. Try login with code@bravescog.internal and user's password
  /// 2. If fails, try with initial technical password
  /// 3. If that succeeds, update password and mark as requires onboarding
  Future<Either<Failure, UserEntity>> activateUser(
    String code,
    String password,
  );

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
