import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../cores/constants/colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'package:mobile/features/statistic/view/dashboard/weight_graph.dart';
import 'package:mobile/features/statistic/models/weight_entry.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
      const token = 'auth_token';

      viewModel.fetchDashboardData(token: token);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: HighlightColors.highlight500,
        foregroundColor: Colors.white,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? Center(child: Text(viewModel.errorMessage!))
          : _buildDashboardBody(context, viewModel),
    );
  }

  Widget _buildDashboardBody(BuildContext context, DashboardViewModel viewModel) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    final consumed = viewModel.totalCaloriesConsumed;
    final burned = viewModel.totalCaloriesBurned;
    final goal = viewModel.caloriesGoal;
    final remaining = goal - consumed; //+ burned;
        final List<WeightEntry> weightEntries = [
      WeightEntry(date: DateTime(2023, 1, 1), weight: 80.5),
      WeightEntry(date: DateTime(2023, 1, 8), weight: 79.8),
      WeightEntry(date: DateTime(2023, 1, 15), weight: 79.2),
      WeightEntry(date: DateTime(2023, 1, 22), weight: 78.5),
      WeightEntry(date: DateTime(2023, 1, 29), weight: 77.9),
      WeightEntry(date: DateTime(2023, 2, 5), weight: 78.2),
      WeightEntry(date: DateTime(2023, 2, 12), weight: 77.5),
      WeightEntry(date: DateTime(2023, 2, 19), weight: 76.8),
      WeightEntry(date: DateTime(2023, 2, 26), weight: 76.2),
      WeightEntry(date: DateTime(2023, 3, 5), weight: 75.5),
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text('Hi there 👋', style: theme.textTheme.headlineMedium),
          Text(today, style: theme.textTheme.titleMedium?.copyWith(color: NeutralColors.dark200)),
          const SizedBox(height: 24),
          _buildCaloriesCard(theme, consumed, goal, remaining),
          const SizedBox(height: 24),
          _buildMacronutrientsCard(theme, viewModel),
          const SizedBox(height: 24),
          _buildQuickLogCard(theme),
          const SizedBox(height: 16),
           WeightGraph(
                entries: weightEntries,
                title: 'Weight History (kg)',
              ),       
          const SizedBox(height: 16),      
        ],
      ),
    );
  }

  Widget _buildCaloriesCard(ThemeData theme, int consumed, int goal, int remaining) {
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
                _calorieBox('Consumed', '$consumed', NutritionColor.fat),
                _calorieBox('Goal', '$goal', NutritionColor.protein),
                _calorieBox('Remaining', '$remaining', NutritionColor.cabs),
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
        Text(label, style: TextStyle(fontSize: 14, color: NeutralColors.dark300)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildMacronutrientsCard(ThemeData theme, DashboardViewModel viewModel) {
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
            _macroRow('Carbs', viewModel.carbsPercent, NutritionColor.cabs),
            _macroRow('Protein', viewModel.proteinPercent, NutritionColor.protein),
            _macroRow('Fat', viewModel.fatPercent, NutritionColor.fat),
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
            value: percent.toDouble() / 100.0,
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
