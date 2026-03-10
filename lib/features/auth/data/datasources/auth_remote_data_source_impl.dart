import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:braves_cog/core/config/auth_constants.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> activateAndLogin(
    String code,
    String userProvidedPassword,
  ) async {
    final technicalEmail = AuthConstants.getTechnicalEmail(code);

    print('🔐 [AUTH] Starting activation for code: $code');
    print('📧 [AUTH] Technical email: $technicalEmail');
    developer.log(
      'Starting activation for code: $code (email: $technicalEmail)',
      name: 'AuthRemoteDataSource',
    );

    try {
      // Step 1: Try primary login with user-provided password
      print('🔓 [AUTH] Attempt 1: Trying with user-provided password');
      developer.log(
        'Attempt 1: Trying with user-provided password',
        name: 'AuthRemoteDataSource',
      );
      final AuthResponse response = await supabaseClient.auth
          .signInWithPassword(
            email: technicalEmail,
            password: userProvidedPassword,
          );

      final user = response.user;
      if (user == null) {
        throw Exception('Login failed: User is null');
      }

      print('✅ [AUTH] Primary login successful');
      developer.log('✓ Primary login successful', name: 'AuthRemoteDataSource');
      return _userToModel(user, isActivated: true);
    } on AuthException catch (e) {
      print(
        '❌ [AUTH] Primary login failed - Status: ${e.statusCode}, Message: ${e.message}',
      );
      developer.log(
        'Primary login failed - Status: ${e.statusCode}, Message: ${e.message}',
        name: 'AuthRemoteDataSource',
      );

      // Step 2: If 400/401, try with initial technical password
      if (e.statusCode == '400' || e.statusCode == '401') {
        try {
          print(
            '🔐 [AUTH] Attempt 2: Trying with technical password (start123)',
          );
          developer.log(
            'Attempt 2: Trying with technical password for activation',
            name: 'AuthRemoteDataSource',
          );
          final AuthResponse technicalResponse = await supabaseClient.auth
              .signInWithPassword(
                email: technicalEmail,
                password: AuthConstants.initialTechnicalPassword,
              );

          final user = technicalResponse.user;
          if (user == null) {
            throw Exception('Technical login failed: User is null');
          }

          print('✅ [AUTH] Technical password login successful');
          developer.log(
            '✓ Technical password login successful',
            name: 'AuthRemoteDataSource',
          );

          // Step 3: Update password to user-provided password
          try {
            await supabaseClient.auth.updateUser(
              UserAttributes(password: userProvidedPassword),
            );
            print('✅ [AUTH] Password updated successfully');
            developer.log(
              '✓ Password updated successfully',
              name: 'AuthRemoteDataSource',
            );
          } catch (updateErr) {
            // Log but don't fail - password update error should not prevent login
            print(
              '⚠️  [AUTH] Password update failed (non-blocking): $updateErr',
            );
            developer.log(
              '⚠ Password update failed (non-blocking): $updateErr',
              name: 'AuthRemoteDataSource',
            );
          }

          // Return user with requiresOnboarding = true
          return _userToModel(user, requiresOnboarding: true);
        } on AuthException catch (technicalErr) {
          print('❌ [AUTH] Technical password login FAILED');
          print('   Status: ${technicalErr.statusCode}');
          print('   Message: ${technicalErr.message}');
          print('   Email attempted: $technicalEmail');
          print(
            '   Password attempted: ${AuthConstants.initialTechnicalPassword}',
          );
          developer.log(
            'Technical password login failed - Status: ${technicalErr.statusCode}, Message: ${technicalErr.message}',
            name: 'AuthRemoteDataSource',
            level: 1000, // Error level
          );

          throw Exception(
            'Activation failed: Invalid code or account not found.\n\n'
            'Details:\n'
            'Email: $technicalEmail\n'
            'Error: ${technicalErr.message}\n'
            'Status: ${technicalErr.statusCode}\n\n'
            'Possible causes:\n'
            '• User account does not exist in Supabase\n'
            '• Account created with different domain/password\n'
            '• Email not confirmed in Supabase',
          );
        }
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('❌ [AUTH] Unexpected error: $e');
      rethrow;
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
}
