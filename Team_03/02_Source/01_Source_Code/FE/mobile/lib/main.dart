import 'package:flutter/material.dart';
import 'package:mobile/views/user_register.dart';
import 'package:mobile/views/user_login.dart';
import 'package:mobile/views/user_survey.dart';
import 'package:mobile/constants/app_routes.dart';
import 'package:mobile/constants/app_color.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor1,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.inverseTextColor),
          bodyMedium: TextStyle(color: AppColors.defaultTextColor),
        ),
      ),
      // Start with the RegisterPage
      initialRoute: AppRoutes.register,
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.register: (_) => const UserRegister(),
        AppRoutes.login: (_) => const UserLogin(),
        AppRoutes.survey  : (_) => const UserSurvey(),
      },
    );
  }
}