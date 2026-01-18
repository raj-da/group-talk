import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/exception.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/core/network/network_info.dart';
import 'package:grouptalk/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    // If device is offline
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await authRemoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );

      return right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMassage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // If device is offline
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await authRemoteDataSource.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      return right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMassage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    // If device is offline
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await authRemoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(failureMassage: e.errorMessage));
    }
  }

  @override
  Stream<UserEntity?> authStateChange() {
    return authRemoteDataSource.authStateChanges();
  }
}
