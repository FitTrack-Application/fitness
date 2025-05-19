import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    // Only show navbar on Dashboard, Diary, and Profile screens
    const List<String> routesWithBottomNavBar = [
      '/dashboard',
      '/diary',
      '/profile',
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar:
          routesWithBottomNavBar.contains(currentRoute) ? const BottomNavBar() : null,
    );
  }
}
