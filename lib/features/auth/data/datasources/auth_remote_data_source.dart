import 'package:braves_cog/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Activate account with invite code and password
  ///
  /// This method implements the silent activation flow:
  /// 1. Try to login with code@bravescog.internal and userProvidedPassword
  /// 2. If that fails (400/401), try with the initial technical password
  /// 3. If technical password succeeds, immediately update to userProvidedPassword
  Future<UserModel> activateAndLogin(String code, String userProvidedPassword);

  Future<UserModel> getCurrentUser();
}
