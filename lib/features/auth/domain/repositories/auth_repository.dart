import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Activate a new user account with invite code and a new password.
  Future<Either<Failure, UserEntity>> activateAccount(
    String code,
    String newPassword,
  );

  /// Login to an already activated account.
  ///
  /// `emailOrCode` can be a full email or an invite code.
  Future<Either<Failure, UserEntity>> login(
    String emailOrCode,
    String password,
  );

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
