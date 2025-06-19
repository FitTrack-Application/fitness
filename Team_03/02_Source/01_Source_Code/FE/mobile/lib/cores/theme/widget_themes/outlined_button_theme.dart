import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/sizes.dart';

import '../../constants/colors.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: HighlightColors.highlight500,
      side: const BorderSide(color: HighlightColors.highlight500),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: HighlightColors.highlight500,
      side: const BorderSide(color: HighlightColors.highlight500),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
