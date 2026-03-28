import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:braves_cog/core/config/env_config.dart';
import 'package:braves_cog/core/services/api_client.dart';
import 'package:braves_cog/core/providers/shared_preferences_provider.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:braves_cog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';
import 'package:braves_cog/features/auth/domain/repositories/auth_repository.dart';
import 'package:braves_cog/features/profile/presentation/providers/profile_provider.dart';

// --- Dependency Injection ---

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: prefs);
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ApiClient(
    baseUrl: EnvConfig.apiBaseUrl,
    supabaseClient: supabase,
    tokenProvider: () async {
      final localAuth = ref.read(authLocalDataSourceProvider);
      return await localAuth.getToken();
    },
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (EnvConfig.useMockData) {
    return AuthMockDataSource();
  }
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(supabaseClient: supabase);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// --- State Management ---

class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserEntity? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final result = await _repository.getCurrentUser();
    result.fold((failure) => state = const AuthState(), (user) {
      state = AuthState(user: user);
      _ref.read(profileProvider.notifier).loadProfile(email: user.email);
    });
  }

  Future<void> activateAccount(String code, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.activateAccount(code, newPassword);
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = AuthState(user: user);
        // Load profile after activation
        if (user.requiresOnboarding) {
          // User needs to complete onboarding, don't load profile yet
          // This is handled in the routing/navigation layer
        } else {
          _ref.read(profileProvider.notifier).loadProfile(email: user.email);
        }
      },
    );
  }

  Future<void> login(String emailOrCode, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.login(emailOrCode, password);
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (user) {
        state = AuthState(user: user);
        if (!user.requiresOnboarding) {
          _ref.read(profileProvider.notifier).loadProfile(email: user.email);
        }
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  Future<void> completeOnboardingInAuth() async {
    // Update the current user to mark onboarding as complete
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(requiresOnboarding: false);
      state = state.copyWith(user: updatedUser);
      // Load profile after onboarding is complete
      _ref.read(profileProvider.notifier).loadProfile(email: updatedUser.email);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});
