import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/onboarding/data/models/consents_model.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';
import 'package:braves_cog/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SharedPreferences sharedPreferences;

  OnboardingRepositoryImpl(this.sharedPreferences);

  static const cachedConsentsKey = 'user-consents';
  static const onboardingCompletedKey = 'onboarding-completed';

  @override
  Future<Either<Failure, Unit>> saveConsents(ConsentsEntity consents) async {
    try {
      final model = ConsentsModel(
        dataCollection: consents.dataCollection,
        adverseEventsMonitoring: consents.adverseEventsMonitoring,
        wantsAdverseEventsMonitoring: consents.wantsAdverseEventsMonitoring,
        pushNotifications: consents.pushNotifications,
      );
      
      await sharedPreferences.setString(
        cachedConsentsKey,
        json.encode(model.toJson()),
      );
      // TODO: Sync to remote if needed
      
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    try {
      await sharedPreferences.setBool(onboardingCompletedKey, true);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final completed = sharedPreferences.getBool(onboardingCompletedKey) ?? false;
      return Right(completed);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
