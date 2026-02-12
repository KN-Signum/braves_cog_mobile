import 'package:dartz/dartz.dart';
import 'package:braves_cog/core/config/env_config.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile({
    String? email,
  }) async {
    // Try to get from local storage first (offline-first approach or cache)
    try {
      final localProfile = await localDataSource.getLastUserProfile();
      if (localProfile != null) {
        return Right(localProfile);
      }
    } catch (e) {
      // Ignore local read errors
    }

    if (EnvConfig.useMockData) {
      try {
        final remoteProfile = await remoteDataSource.getUserProfile(
          email: email,
        );
        await localDataSource.cacheUserProfile(remoteProfile);
        return Right(remoteProfile);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      // TODO: Implement real remote call check
      try {
        final remoteProfile = await remoteDataSource.getUserProfile(
          email: email,
        );
        await localDataSource.cacheUserProfile(remoteProfile);
        return Right(remoteProfile);
      } catch (e) {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> saveUserProfile(
    UserProfileEntity profile,
  ) async {
    try {
      await localDataSource.cacheUserProfile(profile);

      if (EnvConfig.useMockData) {
        await remoteDataSource.updateUserProfile(profile);
      } else {
        // TODO: Implement real remote call
        await remoteDataSource.updateUserProfile(profile);
      }
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
