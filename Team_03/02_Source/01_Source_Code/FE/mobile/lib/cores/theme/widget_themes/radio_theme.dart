import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TRadioTheme {
  TRadioTheme._();

  static final lightRadioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return HighlightColors.highlight500;
      }
      return HighlightColors.highlight500;
    }),
  );

  static final darkRadioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return NeutralColors.light500;
      }
      return NeutralColors.light500;
    }),
  );
}
