import 'package:braves_cog/core/models/user.dart';
import 'package:braves_cog/core/services/api_client.dart';

class MockAuthService {
  final ApiClient apiClient;

  MockAuthService(this.apiClient);

  // Mock user data
  static final Map<String, Map<String, dynamic>> _mockUsers = {
    'test@example.com': {
      'id': '1',
      'email': 'test@example.com',
      'password': 'password123',
      'name': 'Test User',
      'avatarUrl': null,
      'createdAt': DateTime.now().toIso8601String(),
    },
    'admin@example.com': {
      'id': '2',
      'email': 'admin@example.com',
      'password': 'admin123',
      'name': 'Admin User',
      'avatarUrl': null,
      'createdAt': DateTime.now().toIso8601String(),
    },
  };

  // Mock login
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = _mockUsers[email];

    if (mockUser == null) {
      throw ApiException('User not found');
    }

    if (mockUser['password'] != password) {
      throw ApiException('Invalid password');
    }

    // Return user without password
    final userJson = Map<String, dynamic>.from(mockUser);
    userJson.remove('password');

    return User.fromJson(userJson);
  }

  // Mock register
  Future<User> register(String email, String password, String name) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_mockUsers.containsKey(email)) {
      throw ApiException('User already exists');
    }

    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'password': password,
      'name': name,
      'avatarUrl': null,
      'createdAt': DateTime.now().toIso8601String(),
    };

    _mockUsers[email] = newUser;

    // Return user without password
    final userJson = Map<String, dynamic>.from(newUser);
    userJson.remove('password');

    return User.fromJson(userJson);
  }

  // Mock logout
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Mock get current user
  Future<User?> getCurrentUser(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    for (final userData in _mockUsers.values) {
      if (userData['id'] == userId) {
        final userJson = Map<String, dynamic>.from(userData);
        userJson.remove('password');
        return User.fromJson(userJson);
      }
    }

    return null;
  }
}
