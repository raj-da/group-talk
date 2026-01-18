import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription _subscription;

  AuthNotifier({required this.authBloc}) {
    _subscription = authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  bool get isLoggedIn => authBloc.state is AuthAuthenticated;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
