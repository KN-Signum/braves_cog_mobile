import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? token;
  final bool isActivated;
  final bool requiresOnboarding;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.token,
    this.isActivated = false,
    this.requiresOnboarding = true,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    token,
    isActivated,
    requiresOnboarding,
  ];

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    bool? isActivated,
    bool? requiresOnboarding,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      isActivated: isActivated ?? this.isActivated,
      requiresOnboarding: requiresOnboarding ?? this.requiresOnboarding,
    );
  }
}
