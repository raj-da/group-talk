import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String? name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.name,
  });

  @override
  List<Object?> get props => [id, email, isEmailVerified, name];
}
