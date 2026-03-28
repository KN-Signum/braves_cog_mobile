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
  static final Set<String> _activatedCodes = <String>{};

  @override
  Future<UserModel> activateAccount(String code, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency

    // Check if code exists in test accounts
    if (!_testAccounts.containsKey(code)) {
      throw Exception('Nieprawidłowy kod zaproszenia lub konto nie istnieje.');
    }

    if (_activatedCodes.contains(code)) {
      throw Exception('Konto jest już aktywowane. Użyj opcji logowania.');
    }

    _activatedCodes.add(code);

    final userType = _testAccounts[code]!;
    final technicalEmail = AuthConstants.getTechnicalEmail(code);

    return UserModel(
      id: 'mock_user_$code',
      email: technicalEmail,
      name: userType,
      token: 'mock_jwt_token_${code}_12345',
      isActivated: true,
      requiresOnboarding: true,
    );
  }

  @override
  Future<UserModel> login(String emailOrCode, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final code = emailOrCode.contains('@')
        ? emailOrCode.split('@').first
        : emailOrCode;

    if (!_testAccounts.containsKey(code)) {
      throw Exception('Nieprawidłowy kod zaproszenia lub konto nie istnieje.');
    }

    if (!_activatedCodes.contains(code)) {
      throw Exception(
        'Konto nie zostało jeszcze aktywowane. Użyj kodu zaproszenia.',
      );
    }

    if (password != _testUserPassword) {
      throw Exception('Nieprawidłowe hasło.');
    }

    final userType = _testAccounts[code]!;
    final technicalEmail = AuthConstants.getTechnicalEmail(code);
    return UserModel(
      id: 'mock_user_$code',
      email: technicalEmail,
      name: userType,
      token: 'mock_jwt_token_${code}_12345',
      isActivated: true,
      requiresOnboarding: false,
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
