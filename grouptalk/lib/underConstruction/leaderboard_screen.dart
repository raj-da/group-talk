import 'package:flutter/material.dart';
import 'package:grouptalk/core/presentation/screens/underConstructionScreen.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderConstructionScreen(
      title: "Leaderboard",
      subtitle:
          "The leaderboard feature is currently under development.\n\nSoon you will be able to track progress, ranks, and achievements across study rooms.",
      selectedIndex: 2,
    );
  }
}
