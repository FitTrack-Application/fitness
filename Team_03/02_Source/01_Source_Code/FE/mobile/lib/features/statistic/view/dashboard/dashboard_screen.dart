import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/statistic/models/step_entry.dart';
import 'package:mobile/features/statistic/models/weight_entry.dart'
    show WeightEntry;
import 'package:mobile/features/statistic/view/dashboard/widget/weight_graph.dart';
import 'package:mobile/features/statistic/view/dashboard/widget/step_graph.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../cores/constants/colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

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
      viewModel.fetchStepStatistics();
      viewModel.fetchWeightStatistics();
      viewModel.fetchWeightGoal();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!))
              : _buildDashboardBody(context, viewModel),
    );
  }

  Widget _buildDashboardBody(
      BuildContext context, DashboardViewModel viewModel) {
    final theme = Theme.of(context);
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    final consumed = viewModel.totalCaloriesConsumed;
    final burned = viewModel.totalCaloriesBurned;
    final goal = viewModel.caloriesGoal;
    final remaining = goal - consumed; //+ burned;
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: ListView(
            children: [
              Text('Hi there 👋', style: theme.textTheme.headlineMedium),
              Text(today,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: NeutralColors.dark200)),
              const SizedBox(height: 24),
              _buildCaloriesCard(theme, consumed, goal, remaining),
              const SizedBox(height: 24),
              _buildMacronutrientsCard(theme, viewModel),
              const SizedBox(height: 24),
              //_buildQuickLogCard(theme),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.8, // Adjust width for each graph

                      child: WeightGraph(
                        entries: viewModel.weightEntries,
                        title: 'Weights',
                        weightGoal: viewModel.targetWeight ?? 75,
                      ),
                    ),
                    const SizedBox(width: 16), // Add spacing between the graphs
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.8, // Adjust width for each graph

                      child: StepGraph(
                        entries: viewModel.stepEntries,
                        title: 'Steps',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCaloriesCard(
      ThemeData theme, int consumed, int goal, int remaining) {
    final dataMap = <String, double>{
      'Consumed': consumed.toDouble(),
      'Remaining': remaining > 0 ? remaining.toDouble() : 0,
    };

    final colorList = <Color>[
      NutritionColor.fat,
      NutritionColor.cabs,
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartType: ChartType.ring,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 3,
                chartValuesOptions:
                    const ChartValuesOptions(showChartValues: false),
                centerText: goal.toString(),
                initialAngleInDegree: 270,
                centerTextStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AccentColors.yellow200,
                ),
                legendOptions: const LegendOptions(showLegends: false),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calories Today', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _calorieBox('Goal:  ', '$goal', NutritionColor.protein),
                  _calorieBox('Consumed: ', '$consumed', NutritionColor.fat),
                  _calorieBox('Remaining: ', '$remaining', NutritionColor.cabs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calorieBox(String label, String value, Color color) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildMacronutrientsCard(
      ThemeData theme, DashboardViewModel viewModel) {
    final dataMap = <String, double>{
      'Carbs': viewModel.carbsPercent.toDouble(),
      'Protein': viewModel.proteinPercent.toDouble(),
      'Fat': viewModel.fatPercent.toDouble(),
    };

    final colorList = <Color>[
      NutritionColor.cabs,
      NutritionColor.protein,
      NutritionColor.fat,
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartType: ChartType.disc,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                chartValuesOptions:
                    const ChartValuesOptions(showChartValuesInPercentage: true),
                legendOptions: const LegendOptions(showLegends: false),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Macro Nutrients', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _macroRow(
                      'Carbs', viewModel.carbsPercent, NutritionColor.cabs),
                  _macroRow('Protein', viewModel.proteinPercent,
                      NutritionColor.protein),
                  _macroRow('Fat', viewModel.fatPercent, NutritionColor.fat),
                ],
              ),
            ),
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
          Text('$name - $percent%',
              style: TextStyle(
                color: color,
              )),
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

  // Widget _buildQuickLogCard(ThemeData theme) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           _quickAction(Icons.fastfood, 'Food', HighlightColors.highlight500),
  //           _quickAction(Icons.fitness_center, 'Exercise', AccentColors.red300),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
