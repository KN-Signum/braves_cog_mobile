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
      // Persist credentials so the user is auto-logged in on next app start
      await localDataSource.saveCredentials(
        emailOrCode: code,
        password: newPassword,
      );
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
      // Persist credentials so the user is auto-logged in on next app start
      await localDataSource.saveCredentials(
        emailOrCode: emailOrCode,
        password: password,
      );
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Invalidate the Supabase session on the server side
      await remoteDataSource.signOut();
      // Wipe local cache and stored credentials from secure storage
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Strategy B: always re-authenticate using stored credentials.
      // This ensures a fresh Supabase session on every app start.
      final credentials = await localDataSource.loadCredentials();
      if (credentials == null) {
        return const Left(CacheFailure('No stored credentials'));
      }

      // Silent re-authentication — same code path as the login screen
      final userModel = await remoteDataSource.login(
        credentials.emailOrCode,
        credentials.password,
      );
      await localDataSource.cacheUser(userModel);
      if (userModel.token != null) {
        await localDataSource.saveToken(userModel.token!);
      }
      return Right(userModel);
    } catch (e) {
      // Re-auth failed (wrong credentials, network error, account deactivated, etc.)
      // Clear stale credentials so the user sees the login screen.
      await localDataSource.clearUser();
      return Left(ServerFailure(e.toString()));
    }
  }
}
