import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'package:mobile/cores/constants/routes.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, navProvider, child) {
        return BottomNavigationBar(
          currentIndex: navProvider.currentIndex,
          onTap: (index) {
            navProvider.updateIndex(index);
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/diary');
                break;
              case 2:
                context.go('/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Diary'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}
