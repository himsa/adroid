import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
}

class ServerFailure extends Failure {
  final List properties = const <dynamic>[];
  @override
  List<Object?> get props => [properties];
}

class CacheFailure extends Failure {
  final List properties = const <dynamic>[];
  @override
  List<Object?> get props => [properties];
}
