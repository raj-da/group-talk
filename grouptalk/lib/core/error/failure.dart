import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String failureMassage;
  const Failure({required this.failureMassage});

  @override
  List<Object?> get props => [failureMassage];
}

class ServerFailure extends Failure {
  const ServerFailure({super.failureMassage = 'Server Failure'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.failureMassage = 'Cache Failure'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.failureMassage = 'Network Failure'});
}
