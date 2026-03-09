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
}

const cachedUserKey = 'CACHED_USER';
const secureTokenKey = 'SECURE_JWT_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    this.secureStorage = const FlutterSecureStorage(),
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
      );
    } else {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(cachedUserKey);
    await deleteToken();
  }

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
}
