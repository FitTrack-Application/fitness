import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TRadioTheme {
  TRadioTheme._();

  static final lightRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return HighlightColors.highlight500;
      }
      return HighlightColors.highlight500;
    }),
  );

  static final darkRadioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return HighlightColors.highlight500;
      }
      return HighlightColors.highlight500;
    }),
  );
}
