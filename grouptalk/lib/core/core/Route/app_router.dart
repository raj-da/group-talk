// import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/core/router/auth_notifier.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/authentication/presentation/screens/login_screen.dart';
import 'package:grouptalk/features/authentication/presentation/screens/register_screen.dart';
import 'package:grouptalk/features/chat/presentation/screens/chat_page.dart';
import 'package:grouptalk/features/room/presentation/screens/descover_rooms.dart';
import 'package:grouptalk/features/room/presentation/screens/my_rooms_screen.dart';
// import 'package:grouptalk/main.dart';
import 'package:grouptalk/injection_container.dart' as di;

final authNotifier = AuthNotifier(authBloc: di.sl<AuthBloc>());

final GoRouter router = GoRouter(
  refreshListenable: authNotifier,
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
      builder: (context, state) => const MyRoomsScreen(),
    ),

    GoRoute(
      path: '/register',
      name: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/publicRooms',
      name: RouteName.discoverRooms,
      builder: (context, state) => const DescoverRooms(),
    ),

    GoRoute(
      path: '/chat',
      name: RouteName.chat,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return ChatPage(
          roomId: data['roomId'],
          roomName: data['roomName'],
          userId: data['userId'] ?? '',
          userName: data['userName'],
        );
      },
    ),
  ],
);
