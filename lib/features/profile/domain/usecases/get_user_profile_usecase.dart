import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/repositories/profile_repository.dart';

class EmailParams {
  final String? email;
  const EmailParams({this.email});
}

class GetUserProfileUseCase implements UseCase<UserProfileEntity, EmailParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(EmailParams params) async {
    return await repository.getUserProfile(email: params.email);
  }
}
