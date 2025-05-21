import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_provider.dart';
import 'package:mobile/cores/constants/routes.dart';
import 'package:mobile/cores/theme/theme.dart';
import 'package:mobile/features/auth/views/profile/profile_screen.dart';
import 'package:mobile/features/auth/views/splash/splash_screen.dart';
import 'package:mobile/features/fitness/view/diary/diary_screen.dart';
import 'package:mobile/features/statistic/view/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';


void main() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          //ChangeNotifierProvider(create: (_) => DashboardScreen()),
        ],
        child: MyApp(),
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