import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:braves_cog/core/config/auth_constants.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> activateAccount(String code, String newPassword) async {
    final technicalEmail = AuthConstants.getTechnicalEmail(code);

    print('🔐 [AUTH] Starting activation for code: $code');
    print('📧 [AUTH] Technical email: $technicalEmail');
    developer.log(
      'Starting activation for code: $code (email: $technicalEmail)',
      name: 'AuthRemoteDataSource',
    );

    try {
      // Step 1: Login with initial technical password.
      print('🔓 [AUTH] Attempt 1: Trying with technical password');
      developer.log(
        'Attempt 1: Trying with technical password',
        name: 'AuthRemoteDataSource',
      );
      final AuthResponse response = await supabaseClient.auth
          .signInWithPassword(
            email: technicalEmail,
            password: AuthConstants.initialTechnicalPassword,
          );

      final user = response.user;
      if (user == null) {
        throw Exception('Login failed: User is null');
      }

      print('✅ [AUTH] Technical password login successful');
      developer.log(
        '✓ Technical password login successful',
        name: 'AuthRemoteDataSource',
      );

      // If profile already activated, invite was already used.
      final isActivated = await _isProfileActivated(user.id);
      print('🔍 [AUTH] Profile is_activated=$isActivated');
      if (isActivated) {
        await supabaseClient.auth.signOut();
        throw Exception('Konto jest już aktywowane. Użyj opcji logowania.');
      }

      // Step 2: Set user password chosen during activation.
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      print('✅ [AUTH] Password updated successfully');
      developer.log(
        '✓ Password updated successfully',
        name: 'AuthRemoteDataSource',
      );

      // Step 3: Mark profile as activated.
      try {
        await supabaseClient
            .from('profiles')
            .update({'is_activated': true})
            .eq('id', user.id);
        print('✅ [AUTH] Profile marked as activated');
      } catch (e) {
        print('⚠️ [AUTH] Could not update profile is_activated: $e');
      }

      return _userToModel(user, isActivated: true, requiresOnboarding: true);
    } on AuthException catch (e) {
      print(
        '❌ [AUTH] Activation with technical password failed - Status: ${e.statusCode}, Message: ${e.message}',
      );
      developer.log(
        'Activation with technical password failed - Status: ${e.statusCode}, Message: ${e.message}',
        name: 'AuthRemoteDataSource',
      );

      // If technical password failed, check if account is already activated
      // by trying user-provided password and converting it into a clear message.
      if (e.statusCode == '400' || e.statusCode == '401') {
        try {
          final existing = await supabaseClient.auth.signInWithPassword(
            email: technicalEmail,
            password: newPassword,
          );
          if (existing.user != null) {
            await supabaseClient.auth.signOut();
            throw Exception('Konto jest już aktywowane. Użyj opcji logowania.');
          }
        } on AuthException {
          // Ignore, handled by generic message below.
        }

        throw Exception(
          'Nieprawidłowy kod zaproszenia lub konto nie istnieje.',
        );
      } else {
        throw Exception('Aktywacja nie powiodła się: ${e.message}');
      }
    } catch (e) {
      print('❌ [AUTH] Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> login(String emailOrCode, String password) async {
    final loginEmail = _normalizeToTechnicalEmail(emailOrCode);
    print('🔐 [AUTH] Starting login for: $loginEmail');

    try {
      final AuthResponse response = await supabaseClient.auth
          .signInWithPassword(email: loginEmail, password: password);

      final user = response.user;
      if (user == null) {
        throw Exception('Logowanie nie powiodło się.');
      }

      final isActivated = await _isProfileActivated(user.id);
      if (!isActivated) {
        await supabaseClient.auth.signOut();
        throw Exception(
          'Konto nie zostało jeszcze aktywowane. Użyj kodu zaproszenia.',
        );
      }

      return _userToModel(user, isActivated: true, requiresOnboarding: false);
    } on AuthException catch (e) {
      throw Exception('Błąd logowania: ${e.message}');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      return _userToModel(user);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Check if the user's profile has is_activated = true in the profiles table
  Future<bool> _isProfileActivated(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select('is_activated')
          .eq('id', userId)
          .single();
      return (response['is_activated'] as bool?) ?? false;
    } catch (e) {
      print('⚠️ [AUTH] Could not check profile activation status: $e');
      return false;
    }
  }

  /// Convert Supabase User to UserModel
  UserModel _userToModel(
    User user, {
    bool? isActivated,
    bool? requiresOnboarding,
  }) {
    // Extract the user code from the email
    final email = user.email ?? '';
    final code = AuthConstants.extractCodeFromEmail(email);

    return UserModel(
      id: user.id,
      email: email,
      name: user.userMetadata?['name'] ?? code,
      token: supabaseClient.auth.currentSession?.accessToken,
      isActivated:
          isActivated ?? (user.userMetadata?['is_activated'] as bool? ?? false),
      requiresOnboarding:
          requiresOnboarding ??
          (user.userMetadata?['requires_onboarding'] as bool? ?? true),
    );
  }

  String _normalizeToTechnicalEmail(String emailOrCode) {
    final value = emailOrCode.trim();
    if (value.contains('@')) return value;
    return AuthConstants.getTechnicalEmail(value);
  }
}
