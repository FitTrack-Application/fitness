import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/main_screen.dart';
import 'package:mobile/features/auth/views/authentication/welcome_screen.dart';
import 'package:mobile/features/auth/views/profile/user_profile_screen.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/profile/user_goal_screen.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/auth/views/survey/user_survey.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/fitness/view/exercises/exercise_add_screen.dart';
import 'package:mobile/features/fitness/view/exercises/exercise_detail_screen.dart';
import 'package:mobile/features/fitness/view/recipe_detail/create_recipe_screen.dart';
import 'package:mobile/features/fitness/view/recipe_detail/recipe_detail.dart';
import 'package:mobile/features/fitness/view/recipe_detail/search_food_for_recipe.dart';
import 'package:mobile/features/fitness/view/scan_barcode/scan_barcode_screen.dart';
import 'package:mobile/features/fitness/view/search_exercise/search_exercise_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';
import 'package:mobile/features/statistic/view/step/add_step.dart';

import '../../features/fitness/models/meal_log.dart';
import '../../features/fitness/models/recipe.dart';
import '../../features/fitness/view/food_detail/create_food_screen.dart';
import '../../features/fitness/view/food_detail/food_detail_screen.dart';
import '../../features/fitness/view/search_food/search_food_screen.dart';
import 'package:mobile/features/statistic/view/weight/add_weight.dart';
import 'package:provider/provider.dart';

import '../../features/fitness/viewmodels/diary_viewmodel.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
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
      redirect: (context, state) {
        // Get the DiaryViewModel from Provider
        final diaryVM = Provider.of<DiaryViewModel>(context, listen: false);
        // Refresh data
        diaryVM.fetchDiaryForSelectedDate();
        // Return null to continue with the navigation
        return null;
      },
      builder: (context, state) => const MainScreen(child: DiaryScreen()),
    ),
    GoRoute(
      path: '/search/:mealLogId',
      builder: (context, state) {
        final mealLogStr = state.pathParameters['mealLogId']!;

        final mealTypeStr = state.uri.queryParameters['mealType'];
        print('search mealTypeStr: $mealTypeStr');
        MealType mealType = MealType.breakfast;
        if (mealTypeStr != null) {
          try {
            mealType = mealTypeFromString(mealTypeStr);
            print('✅ Parsed mealType: $mealType');
          } catch (e) {
            print('⚠️ Invalid mealType: $mealTypeStr');
          }
        }

        return SearchFoodScreen(
          mealLogId: mealLogStr,
          mealType: mealType,
        );
      },
    ),
    GoRoute(
      path: '/food/:mealLogIdOrMealEntryId/:foodId/:mode/:numberOfServings',
      builder: (context, state) {
        final mealLogOrMealEntryStr =
            state.pathParameters['mealLogIdOrMealEntryId'] ?? '';
        final foodId = state.pathParameters['foodId'] ?? '';
        final mode = state.pathParameters['mode'];
        final isEdit = (mode == 'edit');
        final numberOfServingsStr = state.pathParameters['numberOfServings'];
        final numberOfServings =
            double.tryParse(numberOfServingsStr ?? '1') ?? 1.0;

        // Parse query param
        final mealTypeStr = state.uri.queryParameters['mealType'];
        MealType mealType = MealType.breakfast;
        if (mealTypeStr != null) {
          try {
            mealType = mealTypeFromString(mealTypeStr);
          } catch (e) {
            print('⚠️ Invalid mealType: $mealTypeStr');
          }
        }

        // Parse query param
        final servingUnitId = state.uri.queryParameters['servingUnitId'];

        return FoodDetailScreen(
          foodId: foodId,
          mealLogId: isEdit ? '' : mealLogOrMealEntryStr,
          mealEntryId: isEdit ? mealLogOrMealEntryStr : '',
          isEdit: isEdit,
          numberOfServings: numberOfServings,
          mealType: mealType,
          servingUnitId: servingUnitId,
        );
      },
    ),

    GoRoute(
      path: '/recipe_detail/:mealLogId',
      builder: (context, state) {
        final recipe = state.extra as Recipe;
        final mealLogId = state.pathParameters['mealLogId']!;
        final mealType = mealTypeFromString(state.uri.queryParameters['mealType']!);

        return RecipeDetailScreen(
          recipe: recipe,
          mealLogId: mealLogId,
          mealType: mealType,
        );
      },
      // path: '/recipe/:mealLogIdOrMealEntryId/:foodId/:mode/:numberOfServings',
      // builder: (context, state) {
      //   final recipe = state.extra as Recipe;
      //   final mealLogOrMealEntryStr =
      //       state.pathParameters['mealLogIdOrMealEntryId'] ?? '';
      //   final mode = state.pathParameters['mode'];
      //   final isEdit = (mode == 'edit');
      //   final numberOfServingsStr = state.pathParameters['numberOfServings'];
      //   final numberOfServings =
      //       double.tryParse(numberOfServingsStr ?? '1') ?? 100;
      //   // Parse query param
      //   final mealTypeStr = state.uri.queryParameters['mealType'];
      //   MealType mealType = MealType.breakfast;
      //   if (mealTypeStr != null) {
      //     try {
      //       mealType = mealTypeFromString(mealTypeStr);
      //     } catch (e) {
      //       print('⚠️ Invalid mealType: $mealTypeStr');
      //     }
      //   }
      //
      //   // Parse query param
      //   final servingUnitId = state.uri.queryParameters['servingUnitId'];
      //   return RecipeDetailScreen(
      //     recipe: recipe,
      //     mealLogId: isEdit ? '' : mealLogOrMealEntryStr,
      //     mealType: mealType,
      //   );
      // },
    ),
    GoRoute(
      path: '/search_food_for_recipe',
      builder: (context, state) {
        return const SearchFoodForRecipeScreen();
      },
    ),

    GoRoute(
      path: '/create_food/:mealLogId/:mealType',
      builder: (context, state) {
        final mealLogId = state.pathParameters['mealLogId']!;
        final mealTypeString = state.pathParameters['mealType']!;
        final mealType = mealTypeFromString(mealTypeString);

        return CreateFoodScreen(
          mealogId: mealLogId,
          mealType: mealType,
        );
      },
    ),
    GoRoute(
      path: '/create_recipe/:mealLogId/:mealType',
      //path: '/testing',
      builder: (context, state) {
        final mealLogId = state.pathParameters['mealLogId']!;
        final mealTypeString = state.pathParameters['mealType']!;
        final mealType = mealTypeFromString(mealTypeString);

        return CreateRecipeScreen(
          mealogId: mealLogId,
          mealType: mealType,
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainScreen(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/searchExercise/:workoutLogId',
      builder: (context, state) {
        final exerciseLogStr = state.pathParameters['workoutLogId']!;

        return SearchExerciseScreen(
          workoutLogId: exerciseLogStr,
        );
      },
    ),
    GoRoute(
      path: '/exerciseDetails/:workoutLogId/:exerciseId',
      builder: (context, state) {
        final workoutLogId = state.pathParameters['workoutLogId']!;
        final exerciseId = state.pathParameters['exerciseId']!;

        return ExerciseDetailScreen(
          workoutLogId: workoutLogId,
          exerciseId: exerciseId,
        );
      },
    ),
    GoRoute(
      path: '/create_my_exercise',
      builder: (context, state) {
        return const ExerciseAddScreen();
      },
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
      builder: (context, state) => const UserGoalScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/weight/add',
      builder: (context, state) => const AddWeight(),
    ),
    GoRoute(
      path: '/steps/add',
      builder: (context, state) => const AddStep(),
    ),
    GoRoute(
      path: '/scan',
      builder: (context, state) => const ScanBarcodeScreen(),
    ),
  ],
);
