import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/main_screen.dart';
import 'package:mobile/features/auth/views/authentication/user_login.dart';
import 'package:mobile/features/auth/views/authentication/user_register.dart';
import 'package:mobile/features/auth/views/authentication/welcome_screen.dart';
import 'package:mobile/features/auth/views/profile/user_profile.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/profile/user_goal.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/auth/views/survey/user_survey.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';
import 'package:mobile/features/statistic/view/step/add_step.dart';

import '../../features/fitness/models/food.dart';
import '../../features/fitness/view/food_detail/food_detail_screen.dart';
import '../../features/fitness/view/search_food/search_food_screen.dart';
import 'package:mobile/features/statistic/view/weight/add_weight.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainScreen(child: DashboardScreen()),
    ),
    GoRoute(
      path: '/diary',
      builder: (context, state) => const MainScreen(child: DiaryScreen()),
    ),
    GoRoute(
      path: '/search/:mealLogId',
      builder: (context, state) {
        final mealLogStr = state.pathParameters['mealLogId']!;
        final mealType = state.uri.queryParameters['mealType'] ?? 'Unknown';

        return SearchFoodScreen(
          mealLogId: mealLogStr,
          mealType: mealType,
        );
      },
    ),
    GoRoute(
      path: '/food/:mealLogId/:foodId/:mode',
      builder: (context, state) {
        final mealLogStr = state.pathParameters['mealLogId'] ?? '';
        final foodId = state.pathParameters['foodId'] ?? '';
        final mode = state.pathParameters['mode'];
        final isEdit = (mode == 'edit');

        return FoodDetailScreen(
          foodId: foodId,
          mealLogId: mealLogStr,
          isEdit: isEdit,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainScreen(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => const UserRegister(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const UserLogin(),
    ),
    GoRoute(
      path: '/survey',
      builder: (context, state) {
        // Nhận dữ liệu từ extra
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String? ?? '';
        final password = extra?['password'] as String? ?? '';
        return UserSurvey(email: email, password: password);
      },
    ),
    GoRoute(
      path: '/goal',
      builder: (context, state) => const UserGoal(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const UserProfile(),
    ),
    GoRoute(
      path: '/weight/add',
      builder: (context, state) => const AddWeight(),
    ),
    GoRoute(
      path: '/steps/add',
      builder: (context, state) => const AddStep(),
    ),
  ],
);
