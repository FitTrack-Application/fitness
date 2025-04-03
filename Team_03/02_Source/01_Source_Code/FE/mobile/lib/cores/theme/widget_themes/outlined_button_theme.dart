import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/cores/constants/sizes.dart';

import '../../constants/colors.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: HighlightColors.highlight500,
      side: BorderSide(color: HighlightColors.highlight500),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: HighlightColors.highlight500,
      side: BorderSide(color: HighlightColors.highlight500),
      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
