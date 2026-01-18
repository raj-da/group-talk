import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';
import 'package:grouptalk/features/authentication/domain/repositories/auth_repository.dart';

class GetAuthState {
  final AuthRepository authRepository;

  GetAuthState({required this.authRepository});

  Stream<UserEntity?> call() => authRepository.authStateChange();
}
