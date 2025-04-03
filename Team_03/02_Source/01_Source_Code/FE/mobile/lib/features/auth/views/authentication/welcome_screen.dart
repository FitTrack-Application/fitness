import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'FitTrack',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/welcome_image.jpg', // Đường dẫn tới hình ảnh trong assets
                  width: 300,
                  height: 370,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 300,
                child: Text(
                  'Ready for some wins? Start tracking, it\'s easy!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 330,
                child: ElevatedButtonCustom(
                  onPressed: () {
                    GoRouter.of(context).push('/survey');
                  },
                  text: 'Sign Up For Free',
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),

              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).push('/auth/login');
                },
                child: Text(
                  'Log In',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}