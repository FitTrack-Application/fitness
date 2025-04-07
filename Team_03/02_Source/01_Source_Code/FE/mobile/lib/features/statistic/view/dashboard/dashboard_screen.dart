import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../cores/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: HighlightColors.highlight500,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Hi there 👋',
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              today,
              style: theme.textTheme.titleMedium?.copyWith(
                color: NeutralColors.dark200,
              ),
            ),
            const SizedBox(height: 24),

            _buildCaloriesCard(theme),
            const SizedBox(height: 24),

            _buildMacronutrientsCard(theme),
            const SizedBox(height: 24),

            _buildQuickLogCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesCard(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: HighlightColors.highlight100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Calories Today', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _calorieBox('Consumed', '1,200', NutritionColor.fat),
                _calorieBox('Goal', '2,000', NutritionColor.protein),
                _calorieBox('Remaining', '800', NutritionColor.cabs),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _calorieBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, color: NeutralColors.dark300)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMacronutrientsCard(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macronutrients', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _macroRow('Carbs', 40, NutritionColor.cabs),
            _macroRow('Protein', 60, NutritionColor.protein),
            _macroRow('Fat', 30, NutritionColor.fat),
          ],
        ),
      ),
    );
  }

  Widget _macroRow(String name, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name - $percent%', style: TextStyle(color: color)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent / 100,
            color: color,
            backgroundColor: NeutralColors.light300,
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLogCard(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _quickAction(Icons.fastfood, 'Food', HighlightColors.highlight500),
            _quickAction(Icons.fitness_center, 'Exercise', AccentColors.red300),
            //_quickAction(Icons.local_drink, 'Water', AccentColors.yellow300),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
