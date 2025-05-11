import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/features/fitness/view/recipe_detail/recipe_detail.dart';
import 'package:provider/provider.dart';

import 'common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'cores/constants/colors.dart';
import 'cores/constants/routes.dart';
import 'cores/theme/theme.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/auth/viewmodels/goal_viewmodel.dart';
import 'features/auth/viewmodels/profile_viewmodel.dart';
import 'features/fitness/models/food.dart';
import 'features/fitness/models/recipe.dart';
import 'features/fitness/services/api_client.dart';
import 'features/fitness/viewmodels/diary_viewmodel.dart';
import 'features/fitness/viewmodels/search_food_viewmodel.dart';
import 'features/statistic/services/dashboard_api_service.dart';
import 'features/statistic/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(
            create: (_) => SearchFoodViewModel()..searchFoods()),
        ChangeNotifierProvider(
            create: (_) => DiaryViewModel()..fetchCaloriesGoal()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => GoalViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        Provider<ApiClient>(
            create: (_) => ApiClient(
                'https://54efe02a-ae6e-4055-9391-3a9bd9cac8f1.mock.pstmn.io')),
        ProxyProvider<ApiClient, DashboardApiService>(
          update: (_, client, __) => DashboardApiService(client),
        ),
        ChangeNotifierProxyProvider<DashboardApiService, DashboardViewModel>(
          create: (_) => DashboardViewModel(
              DashboardApiService(ApiClient(''))), // Placeholder
          update: (_, api, __) => DashboardViewModel(api),
        ),
      ],
      child: const MyApp(),
      // child: const MaterialApp(
      //   home: SearchFoodScreen(),
      // ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitTrack',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Recipe recipe = testRecipe();
//     return MaterialApp(
//       title: 'Recipe Creator',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: HighlightColors.highlight500,
//           primary: HighlightColors.highlight500,
//         ),
//         scaffoldBackgroundColor: NeutralColors.light500,
//         textTheme: TextTheme(
//           titleLarge: GoogleFonts.poppins(fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: NeutralColors.dark500),
//           titleMedium: GoogleFonts.poppins(fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: NeutralColors.dark400),
//           bodyLarge: GoogleFonts.poppins(
//               fontSize: 16, color: NeutralColors.dark500),
//           bodyMedium: GoogleFonts.poppins(
//               fontSize: 14, color: NeutralColors.dark400),
//           bodySmall: GoogleFonts.poppins(
//               fontSize: 12, color: NeutralColors.dark300),
//         ),
//       ),
//       home: RecipeDetailScreen(recipe: recipe),
//     );
//   }
// }
//
// final mockFoods = [
//   Food(
//     name: "Grilled Chicken Breast",
//     servingSize: 100,
//     unit: "g",
//     calories: 165,
//     carbs: 0,
//     fat: 3.6,
//     protein: 31, id: '0',
//   ),
//   Food(
//     id: '1',
//     name: "Steamed Broccoli",
//     servingSize: 100,
//     unit: "g",
//     calories: 35,
//     carbs: 7,
//     fat: 0.4,
//     protein: 2.4,
//   ),
//   Food(
//     id: '2',
//     name: "Cooked Brown Rice",
//     servingSize: 150,
//     unit: "g",
//     calories: 165,
//     carbs: 34,
//     fat: 1.4,
//     protein: 3.5,
//   ),
// ];
//
// Recipe testRecipe() {
//   return Recipe(
//   name: "Grilled Chicken & Rice Bowl",
//   description: "A balanced bowl of grilled chicken, brown rice, and broccoli. Great for post-workout meals!",
//   servingSize: 1,
//   unit: "bowl",
//   calories: mockFoods.fold(0, (sum, f) => sum + f.calories),
//   carbs: mockFoods.fold(0, (sum, f) => sum + f.carbs),
//   fat: mockFoods.fold(0, (sum, f) => sum + f.fat),
//   protein: mockFoods.fold(0, (sum, f) => sum + f.protein),
// foodList: mockFoods,
// id: '0');
//
// }
