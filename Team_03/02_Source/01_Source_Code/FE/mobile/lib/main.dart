import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'package:mobile/cores/constants/routes.dart';
import 'package:mobile/cores/theme/theme.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import 'features/fitness/view/search_food/search_food_screen.dart';
import 'features/fitness/viewmodels/search_food_viewmodel.dart';


void main() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          // ChangeNotifierProvider(create: (_) => DashboardScreen()),
          ChangeNotifierProvider(create: (_) => SearchFoodViewModel()..searchFoods()),
        ],
        child: MyApp(),
        // child: const MaterialApp(
        //   home: SearchFoodScreen(),
        // ),
      ),
    );
}

class MyApp extends StatelessWidget {
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