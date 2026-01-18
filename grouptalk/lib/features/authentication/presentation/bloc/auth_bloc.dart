import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/authentication/domain/entities/user_entity.dart';
import 'package:grouptalk/features/authentication/domain/usecases/get_auth_state.dart';
import 'package:grouptalk/features/authentication/domain/usecases/login_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/logout_user.dart';
import 'package:grouptalk/features/authentication/domain/usecases/register_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetAuthState getAuthState;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getAuthState,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      on<AuthStateChangedEvent>(_onAuthStateChanged);
      on<LoginWithEmailEvent>(_onLogin);
      on<RegisterWithEmailEvent>(_onRegister);
      on<LogoutEvent>(_onLogout);

      _authSubscription = getAuthState().listen((user) {
        add(AuthStateChangedEvent(user: user));
      });
    });
  }

  void _onAuthStateChanged(
    AuthStateChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUser(
      email: event.email,
      password: event.password,
    );

    emit(
      result.fold(
        (failure) => AuthError(message: _mapFailureToMessage(failure)),
        (user) => AuthAuthenticated(user: user),
      ),
    );
  }

  Future<void> _onRegister(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUser(
      email: event.email,
      password: event.password,
    );

    emit(
      result.fold(
        (failure) => AuthError(message: _mapFailureToMessage(failure)),
        (user) => AuthAuthenticated(user: user),
      ),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser();

    emit(
      result.fold(
        (failure) => AuthError(message: _mapFailureToMessage(failure)),
        (_) => AuthUnauthenticated(),
      ),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection';
    } else if (failure is ServerFailure) {
      return failure.failureMassage;
    }
    return 'Unexpected error occurred';
  }
}
