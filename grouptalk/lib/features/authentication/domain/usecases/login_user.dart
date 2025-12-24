import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository authRepository;
  LoginUser({required this.authRepository});

  //? call method is a special method that allows you to use the instance
  //? as replacememnt
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) => authRepository.loginWithEmail(email: email, password: password);
}
