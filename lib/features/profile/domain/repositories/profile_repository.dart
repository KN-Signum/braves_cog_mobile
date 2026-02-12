import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile({String? email});
  Future<Either<Failure, Unit>> saveUserProfile(UserProfileEntity profile);
}
