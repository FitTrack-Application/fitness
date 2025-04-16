import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class StepGraphTheme {
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
    return isDarkMode ? NeutralColors.dark400 : NeutralColors.light300;
  }
  
  // Title data style based on theme
  static TextStyle titleDataStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textScaler = MediaQuery.textScalerOf(context);
    final isBoldText = textScaler.scale(1.0) > 1.0;
    
    return TextStyle(
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
      fontWeight: isBoldText ? FontWeight.w900 : FontWeight.bold,
      fontSize: 10,
    );
  }
  
  // Get tooltip background color
  static Color tooltipBgColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? NeutralColors.dark500 : NeutralColors.dark200;
  }
  
  // Get tooltip text color
  static Color tooltipTextColor(BuildContext context) {
    return Colors.white;
  }
}
