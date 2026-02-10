import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';
import 'package:braves_cog/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
