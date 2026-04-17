import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getLastUser();
  Future<void> clearUser();

  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  /// Persist login credentials in secure storage for silent re-authentication.
  Future<void> saveCredentials({
    required String emailOrCode,
    required String password,
  });

  /// Load previously saved credentials. Returns null if none are stored.
  Future<({String emailOrCode, String password})?> loadCredentials();

  /// Remove stored credentials (called on logout).
  Future<void> clearCredentials();
}

const cachedUserKey = 'CACHED_USER';
const secureTokenKey = 'SECURE_JWT_TOKEN';
const secureEmailKey = 'SECURE_EMAIL_OR_CODE';
const securePasswordKey = 'SECURE_PASSWORD';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getLastUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      final userModel = UserModel.fromJson(json.decode(jsonString));
      final token = await getToken();
      return UserModel(
        id: userModel.id,
        email: userModel.email,
        name: userModel.name,
        token: token,
        isActivated: userModel.isActivated,
        requiresOnboarding: userModel.requiresOnboarding,
      );
    } else {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(cachedUserKey);
    await deleteToken();
    await clearCredentials();
  }

  // ── JWT token ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: secureTokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: secureTokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await secureStorage.delete(key: secureTokenKey);
  }

  // ── Login credentials ──────────────────────────────────────────────────────

  @override
  Future<void> saveCredentials({
    required String emailOrCode,
    required String password,
  }) async {
    await secureStorage.write(key: secureEmailKey, value: emailOrCode);
    await secureStorage.write(key: securePasswordKey, value: password);
  }

  @override
  Future<({String emailOrCode, String password})?> loadCredentials() async {
    final emailOrCode = await secureStorage.read(key: secureEmailKey);
    final password = await secureStorage.read(key: securePasswordKey);
    if (emailOrCode != null && password != null) {
      return (emailOrCode: emailOrCode, password: password);
    }
    return null;
  }

  @override
  Future<void> clearCredentials() async {
    await secureStorage.delete(key: secureEmailKey);
    await secureStorage.delete(key: securePasswordKey);
  }
}
