import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authStateChange();
  
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}
