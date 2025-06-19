import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
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
                  'assets/images/welcome3_image.pjpeg', // Đường dẫn tới hình ảnh trong assets
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
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 330,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await authViewModel.login();
                    if (success) {
                      // Check if the survey is completed
                      try {
                        final hasSurvey =
                            await authViewModel.checkSurveyStatus();
                        if (!hasSurvey) {
                          GoRouter.of(context)
                              .go('/survey'); // Navigate to survey
                        } else if (hasSurvey) {
                          GoRouter.of(context)
                              .go('/dashboard'); // Navigate to dashboard
                        }
                      } catch (e) {
                        // Show error message and navigate back to /welcome
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to check survey status')),
                        );
                        GoRouter.of(context).go('/welcome');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login failed')),
                      );
                    }
                  },
                  child: const Text('Sign Up For Free'),
                  // text: 'Sign Up For Free',
                  // textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final success = await authViewModel.login();
                  if (success) {
                    // Check if the survey is completed

                    try {
                      final hasSurvey = await authViewModel.checkSurveyStatus();
                      if (!hasSurvey) {
                        GoRouter.of(context)
                            .go('/survey'); // Navigate to survey
                      } else if (hasSurvey) {
                        GoRouter.of(context)
                            .go('/dashboard'); // Navigate to dashboard
                      }
                    } catch (e) {
                      // Show error message and navigate back to /welcome
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to check survey status')),
                      );
                      GoRouter.of(context).go('/welcome');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed')),
                    );
                  }
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
