import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                navProvider.currentIndex == 0
                    ? Icons.dashboard // Icon khi được chọn
                    : Icons.dashboard_outlined, // Icon khi không được chọn
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navProvider.currentIndex == 1
                    ? Icons.local_library // Icon khi được chọn
                    : Icons.local_library_outlined, // Icon khi không được chọn
              ),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navProvider.currentIndex == 2
                    ? Icons.person // Icon khi được chọn
                    : Icons.person_outlined, // Icon khi không được chọn
              ),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
