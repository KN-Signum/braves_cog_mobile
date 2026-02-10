import 'package:braves_cog/core/services/api_client.dart';
import 'package:braves_cog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:braves_cog/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    final response = await apiClient.post('/auth/register', body: {
      'email': email,
      'password': password,
      'name': name,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get('/auth/me');
    return UserModel.fromJson(response);
  }
}
