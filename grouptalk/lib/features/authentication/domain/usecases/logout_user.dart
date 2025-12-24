import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository authRepository;
  LogoutUser({required this.authRepository});

  Future<Either<Failure, void>> call() => authRepository.logout();
}
