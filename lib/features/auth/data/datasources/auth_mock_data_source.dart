import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

class AuthMockDataSource implements AuthRemoteDataSource {
  static const String _testPassword = 'password';
  static const Map<String, String> _testAccounts = {
    'adhd@test.pl': 'adhd',
    'covid@test.pl': 'covid',
    'hypertension@test.pl': 'hypertension',
    'normal@test.pl': 'normal',
  };

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate latency

    // Check if email exists and password is correct
    if (!_testAccounts.containsKey(email) || password != _testPassword) {
      throw const ServerFailure('Invalid credentials');
    }

    return UserModel(
      id: 'mock_user_${email.split('@')[0]}',
      email: email,
      name: _testAccounts[email]!,
    );
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // In a real mock, we might check a local flag or token,
    // but here we just return a user if "logged in" logic was handled elsewhere
    await Future.delayed(const Duration(milliseconds: 500));
    return const UserModel(
      id: 'mock_user_normal',
      email: 'normal@test.pl',
      name: 'normal',
    );
  }
}
