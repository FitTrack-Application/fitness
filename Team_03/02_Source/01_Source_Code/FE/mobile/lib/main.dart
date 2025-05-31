import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/features/fitness/view/recipe_detail/recipe_detail.dart';
import 'package:mobile/features/fitness/viewmodels/search_exercise_viewmodel.dart';
import 'package:provider/provider.dart';

import 'common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'cores/constants/routes.dart';
import 'cores/theme/theme.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/auth/viewmodels/goal_viewmodel.dart';
import 'features/auth/viewmodels/profile_viewmodel.dart';
import 'features/fitness/services/api_client.dart';
import 'features/fitness/viewmodels/diary_viewmodel.dart';
import 'features/fitness/viewmodels/search_food_viewmodel.dart';
import 'features/statistic/services/dashboard_api_service.dart';
import 'features/statistic/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

void main() {
  final dio = Dio();
  const storage = FlutterSecureStorage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(
            create: (_) => SearchFoodViewModel()..searchFoods()),
        ChangeNotifierProvider(
            create: (_) => SearchExerciseViewModel()..searchExercises()),
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
