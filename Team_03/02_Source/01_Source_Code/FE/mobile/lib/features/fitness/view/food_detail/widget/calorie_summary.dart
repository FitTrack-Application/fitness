import 'package:flutter/material.dart';

import '../../../../../cores/constants/colors.dart';

class CalorieSummary extends StatelessWidget {
  final double calories;
  final double carbs;
  final double fat;
  final double protein;

  const CalorieSummary({
    super.key,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    const colorCarbs = NutritionColor.cabs;
    const colorFat = NutritionColor.fat;
    const colorProtein = NutritionColor.protein;

    // Calculate calories from each nutrient
    final caloriesFromCarbs = carbs * 4;
    final caloriesFromFat = fat * 9;
    final caloriesFromProtein = protein * 4;

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "${calories.toInt()}",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total Calories",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalorieIndicator(
                        context,
                        "Carbs",
                        caloriesFromCarbs.toStringAsFixed(0),
                        colorCarbs,
                        "${carbs.toStringAsFixed(1)}g"
                    ),
                    _buildCalorieIndicator(
                        context,
                        "Fat",
                        caloriesFromFat.toStringAsFixed(0),
                        colorFat,
                        "${fat.toStringAsFixed(1)}g"
                    ),
                    _buildCalorieIndicator(
                        context,
                        "Protein",
                        caloriesFromProtein.toStringAsFixed(0),
                        colorProtein,
                        "${protein.toStringAsFixed(1)}g"
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieIndicator(
      BuildContext context,
      String label,
      String calories,
      Color color,
      String grams,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodySmall,
        ),
        Text(
          "$calories cal",
          style: textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          grams,
          style: textTheme.bodySmall?.copyWith(
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
