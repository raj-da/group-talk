import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.isEmailVerified,
    super.name,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      isEmailVerified: user.emailVerified,
      name: user.displayName,
    );
  }
}
