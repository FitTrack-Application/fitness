import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/main_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => MainScreen(child: DashboardScreen()),
    ),
    GoRoute(
      path: '/diary',
      builder: (context, state) => MainScreen(child: DiaryScreen()),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => MainScreen(child: ProfileScreen()),
    ),
  ],
);
