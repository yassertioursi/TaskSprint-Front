import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class OfflineFailure extends Failure {
  const OfflineFailure()
      : super("No internet connection. Please check your network.");
}

class ServerFailure extends Failure {
  const ServerFailure(
      [String message = "Server error. Please try again later."])
      : super(message);
}
