import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/views/authentication/welcome_screen.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/main_screen.dart';
import 'package:mobile/features/auth/views/survey/user_survey.dart';
import 'package:mobile/features/auth/views/authentication/user_register.dart';
import 'package:mobile/features/auth/views/authentication/user_login.dart';
import 'package:mobile/features/auth/views/profile/user_goal.dart';
import 'package:mobile/features/auth/views/profile/edit_profile.dart';
import '../../features/fitness/view/food_detail/food_detail_screen.dart';
import '../../features/fitness/view/search_food/search_food_screen.dart';
import '';
final GoRouter appRouter = GoRouter(
  initialLocation: '/search',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => MainScreen(child: DashboardScreen()),
    ),
    GoRoute(
      path: '/diary',
      builder: (context, state) => MainScreen(child: DiaryScreen()),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchFoodScreen(),
    ),
    GoRoute(
      path: '/food/:id',
      builder: (context, state) {
        final foodId = state.pathParameters['id']!;
        return FoodDetailScreen(foodId: foodId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => MainScreen(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => UserRegister(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => UserLogin(),
    ),
    GoRoute(
      path: '/survey',
       builder: (context, state) =>  UserSurvey(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchFoodScreen(),
    ),
    GoRoute(
      path: '/goal',
      builder: (context, state) => GoalPage(), 
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => EditProfile(), 
    ),
  ],
);
