import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';
import 'package:braves_cog/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/check_onboarding_completion_usecase.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/save_consents_usecase.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

// Repository Provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingRepositoryImpl(prefs);
});

// Use Cases Providers
final saveConsentsUseCaseProvider = Provider<SaveConsentsUseCase>((ref) {
  return SaveConsentsUseCase(ref.watch(onboardingRepositoryProvider));
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>((
  ref,
) {
  return CompleteOnboardingUseCase(ref.watch(onboardingRepositoryProvider));
});

final checkOnboardingCompletionUseCaseProvider =
    Provider<CheckOnboardingCompletionUseCase>((ref) {
      return CheckOnboardingCompletionUseCase(
        ref.watch(onboardingRepositoryProvider),
      );
    });

// State
enum OnboardingStage {
  logo,
  welcome,
  intro,
  profile,
  consentsIntro,
  consents,
  final_,
  completed,
}

class OnboardingState {
  final OnboardingStage stage;
  final ConsentsEntity consents;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.stage = OnboardingStage.logo,
    this.consents = const ConsentsEntity(),
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    OnboardingStage? stage,
    ConsentsEntity? consents,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      stage: stage ?? this.stage,
      consents: consents ?? this.consents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SaveConsentsUseCase _saveConsentsUseCase;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;
  // ignore: unused_field
  final CheckOnboardingCompletionUseCase _checkOnboardingCompletionUseCase;
  final Ref ref;

  OnboardingNotifier(
    this._saveConsentsUseCase,
    this._completeOnboardingUseCase,
    this._checkOnboardingCompletionUseCase,
    this.ref,
  ) : super(const OnboardingState());

  void setStage(OnboardingStage stage) {
    state = state.copyWith(stage: stage);
  }

  void updateConsents(ConsentsEntity consents) {
    state = state.copyWith(consents: consents);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. Save Profile (via ProfileNotifier)
      final profileNotifier = ref.read(profileProvider.notifier);
      await profileNotifier.saveProfile();
      final profileState = ref.read(profileProvider);

      if (profileState.error != null) {
        state = state.copyWith(
          isLoading: false,
          error: "Błąd zapisania profilu: ${profileState.error}",
        );
        return;
      }

      // 2. Save Consents
      final consentsResult = await _saveConsentsUseCase(state.consents);

      final consentsError = consentsResult.fold<String?>(
        (failure) => failure.message,
        (_) => null,
      );

      if (consentsError != null) {
        state = state.copyWith(isLoading: false, error: consentsError);
        return;
      }

      // 3. Mark Completed
      final completeResult = await _completeOnboardingUseCase(NoParams());

      completeResult.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.message),
        (_) => state = state.copyWith(
          isLoading: false,
          stage: OnboardingStage.completed,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Nieoczekiwany błąd: $e");
    }
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
      final saveConsents = ref.watch(saveConsentsUseCaseProvider);
      final completeOnboarding = ref.watch(completeOnboardingUseCaseProvider);
      final checkCompletion = ref.watch(
        checkOnboardingCompletionUseCaseProvider,
      );

      return OnboardingNotifier(
        saveConsents,
        completeOnboarding,
        checkCompletion,
        ref,
      );
    });
