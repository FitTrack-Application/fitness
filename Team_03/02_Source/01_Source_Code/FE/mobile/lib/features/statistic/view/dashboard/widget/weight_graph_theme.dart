import 'package:flutter/material.dart';
import '../../../../../cores/constants/colors.dart';

class WeightGraphTheme {
  // Container decoration based on theme
  static BoxDecoration containerDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDarkMode ? NeutralColors.dark300 : NeutralColors.light100,
      borderRadius: BorderRadius.circular(12),
    );
  }
  
  // Card title style based on theme
  static TextStyle cardTitleStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Use MediaQuery.textScalerOf for Flutter 3.17
    final textScaler = MediaQuery.textScalerOf(context);
    final isBoldText = textScaler.scale(1.0) > 1.0;
    
    return TextStyle(
      fontSize: 18,
      fontWeight: isBoldText ? FontWeight.w900 : FontWeight.bold,
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
    );
  }
  
  // Grid line color based on theme
  static Color gridLineColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? NeutralColors.dark500 : NeutralColors.light200;
  }
  
  // Title data style based on theme
  static TextStyle titleDataStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Use MediaQuery.textScalerOf for Flutter 3.17
    final textScaler = MediaQuery.textScalerOf(context);
    final isBoldText = textScaler.scale(1.0) > 1.0;
    
    return TextStyle(
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
      fontWeight: isBoldText ? FontWeight.w900 : FontWeight.bold,
      fontSize: 10,
    );
  }
}
