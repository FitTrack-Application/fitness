import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/goal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch goal data when the page is built
    final goalViewModel = Provider.of<GoalViewModel>(context, listen: false);
    goalViewModel.fetchGoal(); // Replace "12345" with the actual user ID

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
      body: Consumer<GoalViewModel>(
        builder: (context, goalViewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Goal Type",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              goalViewModel.goalType,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Starting Weight",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.startingWeight} kg (${goalViewModel.startingDay.toLocal().toString().split(' ')[0]})",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Current Weight",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.currentWeight} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target Weight",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.targetWeight} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.progress.toStringAsFixed(1)}%",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Goal per week",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.goalPerWeek.toStringAsFixed(1)} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}