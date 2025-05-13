import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/goal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class UserGoal extends StatelessWidget {
  const UserGoal({super.key});

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
          double progress = 0.0;
          if (goalViewModel.startingWeight != goalViewModel.targetWeight) {
            progress = ((goalViewModel.startingWeight -
                        goalViewModel.currentWeight) /
                    (goalViewModel.startingWeight - goalViewModel.targetWeight))
                .clamp(0.0, 1.0); // Ensure progress is between 0 and 1
          }
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
                              "Goal per week",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.goalPerWeek.toStringAsFixed(1)} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        const Text(
                          "Weight Progress",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
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
