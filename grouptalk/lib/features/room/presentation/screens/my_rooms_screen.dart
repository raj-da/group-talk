import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';
import 'package:grouptalk/features/room/presentation/widgets/action_buttons.dart';
import 'package:grouptalk/features/room/presentation/widgets/bottom_navbar.dart';
import 'package:grouptalk/features/room/presentation/widgets/header.dart';
import 'package:grouptalk/features/room/presentation/widgets/room_card.dart';
import 'package:grouptalk/features/room/presentation/widgets/search_bar.dart';

class MyRoomsScreen extends StatefulWidget {
  const MyRoomsScreen({super.key});

  @override
  State<MyRoomsScreen> createState() => _MyRoomsScreenState();
}

class _MyRoomsScreenState extends State<MyRoomsScreen> {
  int _selectedIndex = 0;
  String? _lastUserName;
  String? userId;
  String? userName;

  @override
  void initState() {
    context.read<RoomBloc>().add(LoadJoinedRooms());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.goNamed(RouteName.login);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Custom Header
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  debugPrint("My room Screen ============================>");
                  userId = state.user.id;
                  userName = state.user.name;
                  return customHeader(
                    userName: state.user.name ?? '',
                    onLogout: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    mainMessage: "My Study Rooms",
                    smallMessage: "Welcome back, ${state.user.name ?? ''}!",
                  );
                }
                // For other states (loading/unauthenticated) keep showing header with last-known name
                return customHeader(
                  userName: _lastUserName ?? 'Guest',
                  onLogout: () => context.read<AuthBloc>().add(LogoutEvent()),
                  mainMessage: "My Study Rooms",
                  smallMessage: "Welcome back, ${_lastUserName ?? 'Guest'}!",
                );
              },
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  searchBar(),
                  const SizedBox(height: 20),
                  actionButton(context),
                  const SizedBox(height: 20),

                  BlocBuilder<RoomBloc, RoomState>(
                    builder: (context, state) {
                      if (state is RoomLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is RoomLoaded) {
                        if (state.rooms.isEmpty) {
                          return const Center(
                            child: Text('No rooms joined yet'),
                          );
                        }

                        return Column(
                          children: state.rooms.map((room) {
                            return roomCard(
                              id: room.id,
                              title: room.name,
                              description: room.description,
                              isPrivate: !room.isPublic,
                              time: '1 min ago',
                              context: context,
                              userId: userId,
                              userName: userName,
                            );
                          }).toList(),
                        );
                      }

                      if (state is RoomError) {
                        return Text(state.message);
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        bottomNavigationBar: bottomNavBar(context, _selectedIndex),
      ),
    );
  }
}
