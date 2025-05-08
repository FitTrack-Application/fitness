import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: NeutralColors.light500),
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIconColor: HighlightColors.highlight500,
    floatingLabelStyle: const TextStyle(color: NeutralColors.dark500),
    focusedBorder: OutlineInputBorder(
      borderSide:
          const BorderSide(width: 2, color: HighlightColors.highlight500),
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: NeutralColors.dark100),
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIconColor: HighlightColors.highlight500,
      floatingLabelStyle: const TextStyle(color: NeutralColors.light100),
      focusedBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(width: 2, color: HighlightColors.highlight500),
        borderRadius: BorderRadius.circular(12),
      ));
}
