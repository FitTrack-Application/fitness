import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CalorieSummaryTheme {
  static BoxDecoration containerDecoration(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDarkMode ? NeutralColors.dark400 : NeutralColors.light100,
      borderRadius: BorderRadius.circular(12),
      boxShadow: isDarkMode
          ? []
          : [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static TextStyle calorieTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static TextStyle labelTextStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      color: isDarkMode ? NeutralColors.light500 : Colors.grey,
    );
  }

  static TextStyle indicatorLabelStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12,
      color: isDarkMode ? NeutralColors.light100 : NeutralColors.dark500,
    );
  }
}
