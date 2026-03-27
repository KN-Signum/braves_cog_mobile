import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';
import 'package:braves_cog/features/auth/domain/repositories/auth_repository.dart';

class ActivateUserUseCase implements UseCase<UserEntity, ActivateUserParams> {
  final AuthRepository repository;

  ActivateUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(ActivateUserParams params) async {
    return await repository.activateUser(params.code, params.password);
  }
}

class ActivateUserParams extends Equatable {
  final String code;
  final String password;

  const ActivateUserParams({required this.code, required this.password});

  @override
  List<Object> get props => [code, password];
}
