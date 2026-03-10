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
      final localProfile = await localDataSource.getLastUserProfile(
        email: email,
      );
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
        await localDataSource.cacheUserProfile(remoteProfile, email: email);
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
        await localDataSource.cacheUserProfile(remoteProfile, email: email);
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
      print("💾 [PROFILE REPO] Starting profile save...");
      await localDataSource.cacheUserProfile(profile);
      print("💾 [PROFILE REPO] Profile cached locally");

      if (EnvConfig.useMockData) {
        print("💾 [PROFILE REPO] Using mock data source");
        await remoteDataSource.updateUserProfile(profile);
      } else {
        // Update remote profile via Supabase RPC
        print("💾 [PROFILE REPO] Calling remote updateUserProfile...");
        await remoteDataSource.updateUserProfile(profile);
        print("✅ [PROFILE REPO] Profile saved to Supabase!");
      }
      return const Right(unit);
    } catch (e) {
      print("❌ [PROFILE REPO] Error saving profile: $e");
      print("❌ [PROFILE REPO] Stack trace: ${StackTrace.current}");
      return Left(CacheFailure(e.toString()));
    }
  }
}
