import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
