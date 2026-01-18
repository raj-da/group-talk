import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:grouptalk/core/error/exception.dart';
import 'package:grouptalk/features/authentication/data/models/user_model.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Stream<UserEntity?>
  authStateChanges(); //? keep track of authentication state of user
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

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
    required String fullName,
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
      await user.updateDisplayName(fullName);

      await firestore.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw ServerException(errorMessage: e.message ?? 'Registration Failed');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    debugPrint(
      'Auth State Change Function. ==================================================== ',
    );
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        isEmailVerified: user.emailVerified,
      );
    });
  }
}
