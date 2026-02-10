import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/core/usecases/usecase.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:braves_cog/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:braves_cog/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:braves_cog/features/profile/domain/entities/user_profile_entity.dart';
import 'package:braves_cog/features/profile/domain/repositories/profile_repository.dart';
import 'package:braves_cog/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:braves_cog/features/profile/domain/usecases/save_user_profile_usecase.dart';

// Data Sources
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileLocalDataSourceImpl(prefs);
});

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  // Logic to switch between mock and real
  return ProfileMockDataSource(); 
});

// Repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localinfo = ref.watch(profileLocalDataSourceProvider);
  final remoteinfo = ref.watch(profileRemoteDataSourceProvider);

  return ProfileRepositoryImpl(
    localDataSource: localinfo,
    remoteDataSource: remoteinfo,
  );
});

// Use Cases
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(ref.watch(profileRepositoryProvider));
});

final saveUserProfileUseCaseProvider = Provider<SaveUserProfileUseCase>((ref) {
  return SaveUserProfileUseCase(ref.watch(profileRepositoryProvider));
});

// State
class ProfileState {
  final UserProfileEntity profile;
  final bool isLoading;
  final String? error;
  final bool isSaved;

  const ProfileState({
    this.profile = const UserProfileEntity(),
    this.isLoading = false,
    this.error,
    this.isSaved = false,
  });

  ProfileState copyWith({
    UserProfileEntity? profile,
    bool? isLoading,
    String? error,
    bool? isSaved,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final SaveUserProfileUseCase _saveUserProfileUseCase;

  ProfileNotifier(
    this._getUserProfileUseCase,
    this._saveUserProfileUseCase,
  ) : super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getUserProfileUseCase(NoParams());
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (profile) => state = state.copyWith(isLoading: false, profile: profile),
    );
  }

  void updateProfile(UserProfileEntity newProfile) {
    state = state.copyWith(profile: newProfile, isSaved: false);
  }

  Future<void> saveProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _saveUserProfileUseCase(state.profile);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (_) => state = state.copyWith(isLoading: false, isSaved: true),
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final getUseCase = ref.watch(getUserProfileUseCaseProvider);
  final saveUseCase = ref.watch(saveUserProfileUseCaseProvider);
  return ProfileNotifier(getUseCase, saveUseCase);
});
