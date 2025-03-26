import 'package:flutter/material.dart';
import 'package:mobile/cores/theme/widget_themes/calorie_summary_theme.dart';

class CalorieSummary extends StatelessWidget {
  final int calories;

  const CalorieSummary({
    super.key,
    required this.calories,
  });

  static const Color _colorCarbs = Colors.blue;
  static const Color _colorFat = Colors.red;
  static const Color _colorProtein = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: CalorieSummaryTheme.containerDecoration(context),
            child: Column(
              children: [
                Text("$calories", style: CalorieSummaryTheme.calorieTextStyle(context)),
                Text("Total Calories", style: CalorieSummaryTheme.labelTextStyle(context)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalorieIndicator(context, "Carbs", "33%", _colorCarbs),
                    _buildCalorieIndicator(context, "Fat", "43%", _colorFat),
                    _buildCalorieIndicator(context, "Protein", "24%", _colorProtein),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieIndicator(BuildContext context, String label, String percent, Color color) {
    return Column(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(height: 4),
        Text(label, style: CalorieSummaryTheme.indicatorLabelStyle(context)),
        Text(percent, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}