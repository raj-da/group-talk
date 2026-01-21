import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouptalk/core/core/Route/route_name.dart';

Widget bottomNavBar(BuildContext context, int selectedIndex) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: const Color(0xFF009688),
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    onTap: (index) {
      if (index != selectedIndex) {
        switch (index) {
          case 0:
            context.goNamed(RouteName.home);
            break;
          case 1:
            context.goNamed(RouteName.discoverRooms);
            break;
          case 2:
            context.goNamed('leaderboard');
            break;
          case 3:
            context.goNamed('profile');
            break;
        }
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
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
  );
}
