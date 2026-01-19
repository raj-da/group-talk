// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customHeader({required String userName, required VoidCallback onLogout, required String mainMessage, required String smallMessage}) {
  return Container(
    padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
    width: double.infinity,
    color: const Color(0xFF009688),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: User Icon + Name + Logout
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              userName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(), // Pushes the Logout button to the far right
            GestureDetector(
              onTap: onLogout,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text(
          mainMessage,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Welcome back, $userName!",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    ),
  );
}
