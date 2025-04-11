import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'package:mobile/cores/constants/routes.dart';
import 'package:mobile/cores/theme/theme.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:mobile/features/auth/viewmodels/goal_viewmodel.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:mobile/features/statistic/viewmodels/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'features/fitness/services/api_client.dart';
import 'features/fitness/viewmodels/diary_viewmodel.dart';
import 'features/fitness/viewmodels/search_food_viewmodel.dart';
import 'features/statistic/services/dashboard_api_service.dart';
import 'features/statistic/view/dashboard/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => GoalViewModel()),

        Provider<ApiClient>(create: (_) => ApiClient('https://54efe02a-ae6e-4055-9391-3a9bd9cac8f1.mock.pstmn.io')),
        ProxyProvider<ApiClient, DashboardApiService>(
          update: (_, client, __) => DashboardApiService(client),
        ),
        ChangeNotifierProxyProvider<DashboardApiService, DashboardViewModel>(
          create: (_) => DashboardViewModel(DashboardApiService(ApiClient(''))), // Placeholder
          update: (_, api, __) => DashboardViewModel(api),
        ),
        ChangeNotifierProvider(
            create: (_) => SearchFoodViewModel()..searchFoods()),
        ChangeNotifierProvider(
          create: (_) => DiaryViewModel(),
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
