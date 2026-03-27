import 'package:braves_cog/core/config/auth_constants.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

class AuthMockDataSource implements AuthRemoteDataSource {
  static const String _testUserPassword = 'password';
  static const Map<String, String> _testAccounts = {
    // Mock invite codes and their corresponding user types
    'vascog': 'vascog',
    'neurocog': 'neurocog',
    'covidcog': 'covidcog',
    'scccog': 'scccog',
    'normalcog': 'normalcog',
  };

  @override
  Future<UserModel> activateAndLogin(
    String code,
    String userProvidedPassword,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency

    // Check if code exists in test accounts
    if (!_testAccounts.containsKey(code)) {
      throw Exception('Activation failed: Invalid code or account not found.');
    }

    // In mock mode, accept both the test password and the technical password
    if (userProvidedPassword != _testUserPassword &&
        userProvidedPassword != AuthConstants.initialTechnicalPassword) {
      throw Exception('Activation failed: Invalid password.');
    }

    final userType = _testAccounts[code]!;
    final technicalEmail = AuthConstants.getTechnicalEmail(code);

    // If user provided the initial technical password, mark as requires onboarding
    final requiresOnboarding =
        userProvidedPassword == AuthConstants.initialTechnicalPassword;

    return UserModel(
      id: 'mock_user_$code',
      email: technicalEmail,
      name: userType,
      token: 'mock_jwt_token_${code}_12345',
      isActivated: true,
      requiresOnboarding: requiresOnboarding,
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // In a real mock, we might check a local flag or token,
    // but here we just return a user if "logged in" logic was handled elsewhere
    await Future.delayed(const Duration(milliseconds: 500));
    return UserModel(
      id: 'mock_user_normalcog',
      email: AuthConstants.getTechnicalEmail('normalcog'),
      name: 'normalcog',
      token: 'mock_jwt_token_current_user_12345',
      isActivated: true,
      requiresOnboarding: false,
    );
  }
}
