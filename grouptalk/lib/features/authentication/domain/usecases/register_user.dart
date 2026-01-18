import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository authRepository;
  RegisterUser({required this.authRepository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String fullName,
  }) => authRepository.registerWithEmail(email: email, password: password, fullName: fullName);
}
