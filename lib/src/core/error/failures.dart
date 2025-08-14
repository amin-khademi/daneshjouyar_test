import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
