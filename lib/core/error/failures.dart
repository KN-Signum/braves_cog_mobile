import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure([this.message = 'Unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server failure']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed']) : super(message);
}
