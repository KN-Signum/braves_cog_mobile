import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// --- Dependency Injection ---

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: EnvConfig.apiBaseUrl);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: prefs);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (EnvConfig.useMockData) {
    return AuthMockDataSource();
  }
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient: apiClient);
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

  AuthNotifier(this._repository) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = const AuthState(), 
      (user) => state = AuthState(user: user),
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.login(email, password);
    state = result.fold(
      (failure) => state.copyWith(isLoading: false, error: failure.message),
      (user) => AuthState(user: user),
    );
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.register(email, password, name);
    state = result.fold(
      (failure) => state.copyWith(isLoading: false, error: failure.message),
      (user) => AuthState(user: user),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
