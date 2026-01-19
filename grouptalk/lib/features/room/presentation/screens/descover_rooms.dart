import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';
// import 'package:grouptalk/features/room/presentation/widgets/action_buttons.dart';
import 'package:grouptalk/features/room/presentation/widgets/bottom_navbar.dart';
import 'package:grouptalk/features/room/presentation/widgets/discover_card.dart';
import 'package:grouptalk/features/room/presentation/widgets/header.dart';
// import 'package:grouptalk/features/room/presentation/widgets/room_card.dart';
import 'package:grouptalk/features/room/presentation/widgets/search_bar.dart';

class DescoverRooms extends StatefulWidget {
  const DescoverRooms({super.key});

  @override
  State<DescoverRooms> createState() => _DescoverRoomsState();
}

class _DescoverRoomsState extends State<DescoverRooms> {
  int _selectedIndex = 1;
  String? _lastUserName;

  @override
  void initState() {
    context.read<RoomBloc>().add(LoadPublicRooms());
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
      child: BlocListener<RoomBloc, RoomState>(
        listener: (context, state) {
          if (state is RoomActionSuccess) {
            // Defer navigation until after build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(RouteName.home);
            });
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return customHeader(
                      userName: state.user.name ?? '',
                      onLogout: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      mainMessage: 'Discover Rooms',
                      smallMessage: 'Join Public Study Rooms',
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    searchBar(),
                    const SizedBox(height: 20),
                    BlocBuilder<RoomBloc, RoomState>(
                      builder: (context, state) {
                        if (state is RoomLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is RoomLoaded) {
                          if (state.rooms.isEmpty) {
                            return const Center(
                              child: Text('No rooms Found yet'),
                            );
                          }
                          return Column(
                            children: state.rooms.map((room) {
                              return discoverCard(
                                id: room.id,
                                title: room.name,
                                description: room.description,
                                time: '5 min',
                                context: context,
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
      ),
    );
  }
}
