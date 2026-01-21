import 'package:flutter/material.dart';
import 'package:grouptalk/features/room/presentation/widgets/bottom_navbar.dart';

class UnderConstructionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final int selectedIndex;

  const UnderConstructionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009688),
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration-like icon container
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF009688).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  size: 70,
                  color: Color(0xFF009688),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Under Construction",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar(context, selectedIndex),
    );
  }
}
