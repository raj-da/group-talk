import 'package:flutter/material.dart';
import 'package:grouptalk/core/presentation/screens/underConstructionScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnderConstructionScreen(
      title: "Profile",
      subtitle:
          "Your profile page is under construction.\n\nSoon you will be able to manage your account, view activity, and customize your experience.",
        selectedIndex: 3,
    );
  }
}
