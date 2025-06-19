import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class FoodLogScreen extends StatelessWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final meals = viewModel.meals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
        centerTitle: true,
      ),
      body: meals.isEmpty
          ? const Center(child: Text('No meals logged.'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final meal = meals[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.orange),
              title: Text(meal.name),
              trailing: Text('${meal.calories} cal'),
            ),
          );
        },
      ),
    );
  }
}
