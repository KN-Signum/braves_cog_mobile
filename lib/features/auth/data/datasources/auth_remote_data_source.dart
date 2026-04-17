import 'package:braves_cog/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Activate account once using invite code and a new user password.
  Future<UserModel> activateAccount(String code, String newPassword);

  /// Login using invite code OR technical email and user password.
  Future<UserModel> login(String emailOrCode, String password);

  Future<UserModel> getCurrentUser();

  /// Sign out from Supabase, invalidating the current session.
  Future<void> signOut();
}
