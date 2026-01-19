import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';
import 'package:grouptalk/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:grouptalk/features/room/presentation/bloc/room_bloc.dart';
import 'package:grouptalk/features/room/presentation/widgets/action_buttons.dart';
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
                  return customHeader(
                    userName: 'Dereje',
                    onLogout: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                  );
                }
                return const SizedBox.shrink();
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
                              title: room.name,
                              description: room.description,
                              isPrivate: !room.isPublic,
                              time: '1 min ago',
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
                  // roomCard(
                  //   title: 'Data Structures Study Group',
                  //   description:
                  //       'Learning algorithms and data structure together',
                  //   isPrivate: false,
                  //   time: '5min ago',
                  // ),
                  // roomCard(
                  //   title: 'Calculus Help Room',
                  //   description: 'Derivatives, integrals, and limits',
                  //   isPrivate: false,
                  //   time: '1 houre ago',
                  // ),
                  // roomCard(
                  //   title: 'Chemistry Lab Prep',
                  //   description: 'Preparing for lab experiments',
                  //   isPrivate: true,
                  //   time: '2 houre ago',
                  // ),
                ],
              ),
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF009688),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
