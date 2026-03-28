import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';
import 'package:braves_cog/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> activateAccount(
    String code,
    String newPassword,
  ) async {
    try {
      final userModel = await remoteDataSource.activateAccount(
        code,
        newPassword,
      );
      await localDataSource.cacheUser(userModel);
      if (userModel.token != null) {
        await localDataSource.saveToken(userModel.token!);
      }
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String emailOrCode,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.login(emailOrCode, password);
      await localDataSource.cacheUser(userModel);
      if (userModel.token != null) {
        await localDataSource.saveToken(userModel.token!);
      }
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // First check local cache
      final localUser = await localDataSource.getLastUser();
      return Right(localUser);
    } catch (e) {
      // If no local user, try remote (optional, depending on auth strategy)
      // For now we assume if no local user, user is logged out
      return const Left(CacheFailure('No user logged in'));
    }
  }
}
