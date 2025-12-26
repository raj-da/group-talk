import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/features/authentication/presentation/screens/login_screen.dart';
import 'package:grouptalk/features/authentication/presentation/screens/register_screen.dart';
import 'package:grouptalk/main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
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
