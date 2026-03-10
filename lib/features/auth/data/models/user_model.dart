import 'package:braves_cog/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.token,
    super.isActivated,
    super.requiresOnboarding,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String?,
      isActivated: json['isActivated'] as bool? ?? false,
      requiresOnboarding: json['requiresOnboarding'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (token != null) 'token': token,
      'isActivated': isActivated,
      'requiresOnboarding': requiresOnboarding,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      token: entity.token,
      isActivated: entity.isActivated,
      requiresOnboarding: entity.requiresOnboarding,
    );
  }
}
