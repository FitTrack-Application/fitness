import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/goal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/value_picker/value_picker.dart';

class UserGoalScreen extends StatelessWidget {
  const UserGoalScreen({super.key});

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
          if (goalViewModel.userGoal.startingWeight !=
              goalViewModel.userGoal.goalWeight) {
            progress = ((goalViewModel.userGoal.startingWeight -
                        goalViewModel.userGoal.currentWeight) /
                    (goalViewModel.userGoal.startingWeight -
                        goalViewModel.userGoal.goalWeight))
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
                              goalViewModel.determineGoalType(),
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
                              "${goalViewModel.userGoal.startingWeight} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Starting Date",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "${goalViewModel.userGoal.startingDate.toLocal().toString().split(' ')[0]}",
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
                              "${goalViewModel.userGoal.currentWeight} kg",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ValuePicker<double>(
                                  values: List.generate(
                                      171,
                                      (index) =>
                                          30 +
                                          index.toDouble()), // 30 to 200 kg
                                  initialValue:
                                      goalViewModel.userGoal.goalWeight,
                                  onValueChanged: (newWeight) {
                                    goalViewModel.userGoal.goalWeight =
                                        newWeight;
                                    goalViewModel
                                        .notifyListeners(); // Update the UI
                                  },
                                  displayText: (value) => "$value kg",
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Target Weight",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "${goalViewModel.userGoal.goalWeight.toStringAsFixed(1)} kg",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
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
                              "${goalViewModel.userGoal.weeklyGoal.toStringAsFixed(1)} kg",
                              style: Theme.of(context).textTheme.displaySmall,
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
