import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? NeutralColors.dark400 
                  : NeutralColors.light400,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Starting Weight",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "70 kg (26/03/2025)",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Weight",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "68 kg",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Goal Weight",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "65 kg",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weekly Goal",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Lose 0.5 kg per week",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activity Level",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Moderate Activity", // Example placeholder text
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Calorie goal",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "2400",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
