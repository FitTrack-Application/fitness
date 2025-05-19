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
                  "$calories",
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
                    _buildCalorieIndicator(context, "Carbs",
                        _calculatePercentage(carbs), colorCarbs),
                    _buildCalorieIndicator(
                        context, "Fat", _calculatePercentage(fat), colorFat),
                    _buildCalorieIndicator(context, "Protein",
                        _calculatePercentage(protein), colorProtein),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tính phần trăm dựa trên calo tổng cộng
  String _calculatePercentage(double nutrientValue) {
    if (calories == 0) return "0%"; // Tránh chia cho 0
    double percentage = (nutrientValue / calories) * 100;
    return "${percentage.toStringAsFixed(1)}%"; // Chuyển đổi thành chuỗi với 1 chữ số thập phân
  }

  Widget _buildCalorieIndicator(
      BuildContext context, String label, String percent, Color color) {
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
          percent,
          style: textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
