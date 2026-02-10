import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:braves_cog/core/error/failures.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel> getLastUser();
  Future<void> clearUser();
}

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw const CacheFailure();
    }
  }
  
  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(CACHED_USER);
  }
}
