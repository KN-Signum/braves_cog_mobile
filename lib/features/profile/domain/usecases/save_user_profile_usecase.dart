import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/repositories/profile_repository.dart';

class SaveUserProfileUseCase implements UseCase<Unit, UserProfileEntity> {
  final ProfileRepository repository;

  SaveUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UserProfileEntity params) async {
    return await repository.saveUserProfile(params);
  }
}
