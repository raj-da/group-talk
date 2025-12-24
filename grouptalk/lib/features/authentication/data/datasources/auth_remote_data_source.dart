import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouptalk/core/error/exception.dart';
import 'package:grouptalk/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw ServerException(errorMessage: 'User not found');
      }

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(errorMessage: e.message ?? 'Authentication Failed');
    }
  }

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw ServerException(errorMessage: 'User Creation failed');
      }

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(errorMessage: e.message ?? 'Registration Failed');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
