import 'package:flutter/material.dart';
import 'package:mobile/cores/theme/widget_themes/calorie_summary_theme.dart';

class CalorieSummary extends StatelessWidget {
  final int calories;
  final int carbs;
  final int fat;
  final int protein;

  const CalorieSummary({
    super.key,
    required this.calories, required this.carbs, required this.fat, required this.protein,
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
                    _buildCalorieIndicator(context, "Carbs", _calculatePercentage(carbs), _colorCarbs),
                    _buildCalorieIndicator(context, "Fat", _calculatePercentage(fat), _colorFat),
                    _buildCalorieIndicator(context, "Protein", _calculatePercentage(protein), _colorProtein),
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
  String _calculatePercentage(int nutrientValue) {
    if (calories == 0) return "0%"; // Tránh chia cho 0
    double percentage = (nutrientValue / calories) * 100;
    return "${percentage.toStringAsFixed(1)}%"; // Chuyển đổi thành chuỗi với 1 chữ số thập phân
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