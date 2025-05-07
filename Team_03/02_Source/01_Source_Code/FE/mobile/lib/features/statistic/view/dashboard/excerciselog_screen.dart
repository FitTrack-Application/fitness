import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class ExerciseLogScreen extends StatelessWidget {
  const ExerciseLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final activities = viewModel.activities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Log'),
        centerTitle: true,
      ),
      body: activities.isEmpty
          ? const Center(child: Text('No activities logged.'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.directions_run, color: Colors.redAccent),
              title: Text(activity.name),
              trailing: Text('${activity.caloriesBurned} cal'),
            ),
          );
        },
      ),
    );
  }
}
