import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SelectBoxTheme {
  static BoxDecoration containerDecoration(
      BuildContext context, bool isSelected) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDarkMode ? NeutralColors.dark300 : NeutralColors.light100,
      border: Border.all(
        color: isSelected
            ? (isDarkMode
                ? HighlightColors.highlight400
                : HighlightColors.highlight500)
            : Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(14.0),
    );
  }

  static TextStyle labelTextBoxStyle(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14,
      color: isDarkMode ? NeutralColors.light500 : NeutralColors.dark500,
    );
  }
}
