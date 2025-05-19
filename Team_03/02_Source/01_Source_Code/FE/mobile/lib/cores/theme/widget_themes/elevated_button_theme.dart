import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      foregroundColor: NeutralColors.light100,
      backgroundColor: HighlightColors.highlight500,
      //side: const BorderSide(color: HighlightColors.highlight500),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0), // Optional: Add padding
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      foregroundColor: NeutralColors.dark500,
      backgroundColor: HighlightColors.highlight400,
      //side: const BorderSide(color: HighlightColors.highlight500),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0), // Optional: Add padding
    ),
  );
}
