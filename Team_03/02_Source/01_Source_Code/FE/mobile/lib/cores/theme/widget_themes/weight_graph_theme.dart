import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class WeightGraphTheme {
  static BoxDecoration containerDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDarkMode ? NeutralColors.dark100 : NeutralColors.light100,
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? NeutralColors.light100 : NeutralColors.dark500,
          blurRadius: 4.0, 
          offset: const Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(14.0),
    );
  }
  static TextStyle cardTitleStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
    );
  }
  static FlLine gridLineStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FlLine(
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
      strokeWidth: 1,
    );
  }
  static TextStyle titleDataStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      color: isDarkMode ? Colors.white70 : Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
  }
}
