import 'package:braves_cog/core/models/user.dart';
import 'package:braves_cog/core/services/api_client.dart';
import 'package:braves_cog/core/services/mock_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://api.example.com');
});

// Auth Service Provider
final authServiceProvider = Provider<MockAuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MockAuthService(apiClient);
});

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final MockAuthService _authService;
  static const String _userIdKey = 'user_id';

  AuthNotifier(this._authService) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userIdKey);

      if (userId != null) {
        final user = await _authService.getCurrentUser(userId);
        if (user != null) {
          state = AuthState(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          return;
        }
      }

      state = AuthState(isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.login(email, password);

      // Save user ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, user.id);

      state = AuthState(user: user, isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.register(email, password, name);

      // Save user ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, user.id);

      state = AuthState(user: user, isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();

      // Clear user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);

      state = AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
