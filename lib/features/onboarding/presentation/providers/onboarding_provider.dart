import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/auth/presentation/providers/auth_provider.dart';
import 'package:braves_cog/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:braves_cog/features/onboarding/domain/entities/consents_entity.dart';
import 'package:braves_cog/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/check_onboarding_completion_usecase.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:braves_cog/features/onboarding/domain/usecases/save_consents_usecase.dart';
import 'package:braves_cog/features/profile/domain/entities/biological_sex.dart';
import 'package:braves_cog/features/profile/domain/entities/education_level.dart';
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
  final OnboardingRepository _repository;
  final Ref ref;

  OnboardingNotifier(
    this._saveConsentsUseCase,
    this._completeOnboardingUseCase,
    this._checkOnboardingCompletionUseCase,
    this._repository,
    this.ref,
  ) : super(const OnboardingState());

  void setStage(OnboardingStage stage) {
    state = state.copyWith(stage: stage);
  }

  void updateConsents(ConsentsEntity consents) {
    state = state.copyWith(consents: consents);
  }

  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    final repository = _repository as OnboardingRepositoryImpl;
    await repository.saveOnboardingData(data);

    // Extract demographic data and update ProfileNotifier with it
    _updateProfileWithDemographicData(data);
  }

  Future<void> moveToPostProfileStage() async {
    final repository = _repository as OnboardingRepositoryImpl;
    final hasConsents = await repository.hasSavedConsents();
    state = state.copyWith(
      stage: hasConsents
          ? OnboardingStage.final_
          : OnboardingStage.consentsIntro,
    );
  }

  void _updateProfileWithDemographicData(Map<String, dynamic> allAnswers) {
    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      final currentProfile = ref.read(profileProvider).profile;

      // Start from current profile values so only answered fields are overwritten
      int birthYear = currentProfile.birthYear;
      int height = currentProfile.height;
      int weight = currentProfile.weight;
      BiologicalSex biologicalSex = currentProfile.biologicalSex;
      String genderIdentity = currentProfile.genderIdentity;
      String genderIdentityOther = currentProfile.genderIdentityOther;
      EducationLevel education = currentProfile.education;
      String educationOther = currentProfile.educationOther;
      String disability = currentProfile.disability;
      bool smokingCigarettes = currentProfile.smokingCigarettes;
      String smokingFrequency = currentProfile.smokingFrequency;
      bool drinkingAlcohol = currentProfile.drinkingAlcohol;
      String alcoholFrequency = currentProfile.alcoholFrequency;
      bool otherSubstances = currentProfile.otherSubstances;
      String otherSubstancesName = currentProfile.otherSubstancesName;
      String otherSubstancesFrequency = currentProfile.otherSubstancesFrequency;
      List<String> medications = currentProfile.medications;
      String chronicDiseases = currentProfile.chronicDiseases;
      String currentIllness = currentProfile.currentIllness;

      // ── DEMOGRAPHIC MODULE ──────────────────────────────────────────────────
      final demographicModule =
          (allAnswers['Demographic'] as Map<String, dynamic>?) ?? {};
      final demographicAnswers = demographicModule.values.isNotEmpty
          ? demographicModule.values.first as Map<String, dynamic>?
          : <String, dynamic>{};

      if (demographicAnswers != null && demographicAnswers.isNotEmpty) {
        print("📊 Demographic answers: $demographicAnswers");
        demographicAnswers.forEach((key, value) {
          switch (key) {
            case 'birth_year':
              if (value is int)
                birthYear = value;
              else if (value is String)
                birthYear = int.tryParse(value) ?? birthYear;
            case 'height':
              if (value is int)
                height = value;
              else if (value is String)
                height = int.tryParse(value) ?? height;
            case 'weight':
              if (value is int)
                weight = value;
              else if (value is String)
                weight = int.tryParse(value) ?? weight;
            case 'biological_sex':
              if (value is String)
                biologicalSex = BiologicalSex.fromString(value);
            case 'gender_identity':
              if (value is String) genderIdentity = value;
            case 'gender_identity_other':
              if (value is String) genderIdentityOther = value;
            case 'education':
              if (value is String) education = EducationLevel.fromString(value);
            case 'education_other':
              if (value is String) educationOther = value;
            case 'disability':
              if (value is String) disability = value;
          }
        });
      }

      // ── SUBSTANCE USE (Baseline_Lifestyle → Baseline_Substance_Use) ─────────
      final lifestyleModule =
          (allAnswers['Baseline_Lifestyle'] as Map<String, dynamic>?) ?? {};
      final substanceAnswers =
          (lifestyleModule['Baseline_Substance_Use']
              as Map<String, dynamic>?) ??
          {};

      if (substanceAnswers.isNotEmpty) {
        print("🚬 Substance answers: $substanceAnswers");
        // Nicotine → smoking
        smokingCigarettes =
            (substanceAnswers['su_nicotine_enabled'] as bool?) ??
            smokingCigarettes;
        smokingFrequency =
            (substanceAnswers['su_nicotine_frequency'] as String?) ??
            smokingFrequency;
        // Alcohol
        drinkingAlcohol =
            (substanceAnswers['su_alcohol_enabled'] as bool?) ??
            drinkingAlcohol;
        alcoholFrequency =
            (substanceAnswers['su_alcohol_frequency'] as String?) ??
            alcoholFrequency;
        // Other substances: aggregate into otherSubstances* fields
        final otherSubstanceMap = {
          'su_cannabinoids': 'cannabinoids',
          'su_sedatives': 'sedatives',
          'su_stimulants': 'stimulants',
          'su_opioids': 'opioids',
          'su_hallucinogens': 'hallucinogens',
        };
        final confirmedOthers = <String>[];
        String firstOtherFreq = '';
        for (final entry in otherSubstanceMap.entries) {
          final enabled =
              (substanceAnswers['${entry.key}_enabled'] as bool?) ?? false;
          if (enabled) {
            confirmedOthers.add(entry.value);
            if (firstOtherFreq.isEmpty) {
              firstOtherFreq =
                  (substanceAnswers['${entry.key}_frequency'] as String?) ?? '';
            }
          }
        }
        otherSubstances = confirmedOthers.isNotEmpty;
        otherSubstancesName = confirmedOthers.isNotEmpty
            ? confirmedOthers.join(', ')
            : '';
        otherSubstancesFrequency = confirmedOthers.isNotEmpty
            ? firstOtherFreq
            : '';
      }

      // ── MEDICATIONS (Baseline_Medical_History → Baseline_Medications) ───────
      final medicalHistoryModule =
          (allAnswers['Baseline_Medical_History'] as Map<String, dynamic>?) ??
          {};
      final medicationsAnswers =
          (medicalHistoryModule['Baseline_Medications']
              as Map<String, dynamic>?) ??
          {};

      if (medicationsAnswers.isNotEmpty) {
        final medsList =
            (medicationsAnswers['medications_medications'] as List<dynamic>?) ??
            [];
        final extractedNames = medsList
            .whereType<Map>()
            .map(
              (m) =>
                  (m['name']?.toString() ?? m['medication']?.toString() ?? ''),
            )
            .where((name) => name.isNotEmpty)
            .toList();
        if (extractedNames.isNotEmpty) medications = extractedNames;
        print("💊 Medications: $medications");
      }

      // ── DISEASES (somatic + mental → chronicDiseases as JSON) ────────────────
      final somaticAnswers =
          (medicalHistoryModule['Baseline_Somatic_Disease']
              as Map<String, dynamic>?) ??
          {};
      final mentalAnswers =
          (medicalHistoryModule['Baseline_Mental_Health_Disorders']
              as Map<String, dynamic>?) ??
          {};

      if (somaticAnswers.isNotEmpty || mentalAnswers.isNotEmpty) {
        final diseaseMap = <String, dynamic>{};
        for (final answers in [somaticAnswers, mentalAnswers]) {
          for (final entry in answers.entries) {
            if (entry.key.endsWith('_enabled') && entry.value == true) {
              final baseKey = entry.key.substring(
                0,
                entry.key.length - '_enabled'.length,
              );
              final dontKnow =
                  (answers['${baseKey}_dont_know'] as bool?) ?? false;
              if (!dontKnow) {
                final subtypes =
                    (answers['${baseKey}_subtypes'] as List<dynamic>?)
                        ?.cast<String>() ??
                    [];
                final otherText =
                    answers['${baseKey}_other_text'] as String? ?? '';
                diseaseMap[baseKey] = {
                  if (subtypes.isNotEmpty) 'subtypes': subtypes,
                  if (otherText.isNotEmpty) 'other_text': otherText,
                };
              }
            }
          }
        }
        if (diseaseMap.isNotEmpty) {
          chronicDiseases = json.encode(diseaseMap);
          print("🏥 Confirmed diseases: $chronicDiseases");
        }
      }

      // ── UPDATE PROFILE ───────────────────────────────────────────────────────
      final updatedProfile = currentProfile.copyWith(
        birthYear: birthYear,
        height: height,
        weight: weight,
        biologicalSex: biologicalSex,
        genderIdentity: genderIdentity,
        genderIdentityOther: genderIdentityOther,
        education: education,
        educationOther: educationOther,
        disability: disability,
        smokingCigarettes: smokingCigarettes,
        smokingFrequency: smokingFrequency,
        drinkingAlcohol: drinkingAlcohol,
        alcoholFrequency: alcoholFrequency,
        otherSubstances: otherSubstances,
        otherSubstancesName: otherSubstancesName,
        otherSubstancesFrequency: otherSubstancesFrequency,
        medications: medications,
        chronicDiseases: chronicDiseases,
        currentIllness: currentIllness,
      );

      print(
        "✅ Updated profile: birthYear=$birthYear, height=$height, weight=$weight, "
        "sex=${biologicalSex.value}, education=${education.value}, "
        "smoking=$smokingCigarettes, drinking=$drinkingAlcohol, "
        "meds=${medications.length}, diseases=${chronicDiseases.isNotEmpty}",
      );
      profileNotifier.updateProfile(updatedProfile);
    } catch (e) {
      print("❌ Error updating profile with survey data: $e");
    }
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

      // 1.5. Invalidate profile cache to force fresh load from Supabase
      ref.invalidate(profileProvider);

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
        (_) {
          // Update auth state to mark onboarding as complete
          ref.read(authProvider.notifier).completeOnboardingInAuth();
          state = state.copyWith(
            isLoading: false,
            stage: OnboardingStage.completed,
          );
        },
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
      final repository = ref.watch(onboardingRepositoryProvider);

      return OnboardingNotifier(
        saveConsents,
        completeOnboarding,
        checkCompletion,
        repository,
        ref,
      );
    });
