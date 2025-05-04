import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.loadLoginState();

    // Delay ngắn cho thấy logo
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      if (authViewModel.isLoggedIn) {
        context.go('/dashboard');
      } else {
        context.go('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'FitTrack',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
