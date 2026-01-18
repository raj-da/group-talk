import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/core/router/auth_notifier.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/authentication/presentation/screens/login_screen.dart';
import 'package:grouptalk/features/authentication/presentation/screens/register_screen.dart';
import 'package:grouptalk/main.dart';
import 'package:grouptalk/injection_container.dart' as di;

final authNotifier = AuthNotifier(authBloc: di.sl<AuthBloc>());

final GoRouter router = GoRouter(
  refreshListenable: authNotifier,
  initialLocation: '/login',
  // redirect: (context, state) {
  //   debugPrint('I am here! ==================================>');
  //   final loggedIn = authNotifier.isLoggedIn;
  //   final loggingIn = state.matchedLocation == '/login';

  //   if (!loggedIn && !loggingIn) return '/login';
  //   if (loggedIn && loggingIn) return '/home';

  //   return null;
  // },
  routes: [
    GoRoute(
      path: '/login',
      name: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/home',
      name: RouteName.home,
      builder: (context, state) => const MyHomePage(title: 'Grouptalk'),
    ),

    GoRoute(
      path: '/register',
      name: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
