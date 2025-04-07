import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/main_screen.dart';
import 'package:mobile/features/auth/views/authentication/user_login.dart';
import 'package:mobile/features/auth/views/authentication/user_register.dart';
import 'package:mobile/features/auth/views/authentication/welcome_screen.dart';
import 'package:mobile/features/auth/views/profile/edit_profile.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/profile/user_goal.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/auth/views/survey/user_survey.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';

import '../../features/fitness/view/food_detail/food_detail_screen.dart';
import '../../features/fitness/view/search_food/search_food_screen.dart';
import 'package:mobile/features/statistic/view/weight/add_weight.dart';
final GoRouter appRouter = GoRouter(
  initialLocation: '/diary',
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
      path: '/search/:diaryId',
      builder: (context, state) {
        final diaryIdStr = state.pathParameters['diaryId']!;
        final diaryId = int.tryParse(diaryIdStr) ?? 0;

        return SearchFoodScreen(diaryId: diaryId);
      },
    ),
    GoRoute(
      path: '/food/:diaryId/:foodId/:mode',
      builder: (context, state) {
        final diaryIdStr = state.pathParameters['diaryId'] ?? '';
        final foodId = state.pathParameters['foodId'] ?? '';
        final mode = state.pathParameters['mode'];

        final diaryId = int.tryParse(diaryIdStr) ?? 0;
        final isEdit = (mode == 'edit');

        return FoodDetailScreen(
          foodId: foodId,
          diaryId: diaryId,
          isEdit: isEdit,
        );
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
      path: '/goal',
      builder: (context, state) => GoalPage(), 
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => EditProfile(), 
    ),
        GoRoute(
      path: '/weight/add',
      builder: (context, state) => AddWeight(), 
    ),
  ],
);
