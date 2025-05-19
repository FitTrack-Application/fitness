import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TColorSchemeTheme {
  TColorSchemeTheme._();

  static const lightColorSchemeTheme = ColorScheme.light(
    primary: HighlightColors.highlight500,
    onPrimary: NeutralColors.light100,
    surface: NeutralColors.light300,
    error: SupportColors.error300,
    onError: NeutralColors.light100,
    //primaryContainer: HighlightColors.highlight300,
    //surfaceBright: HighlightColors.highlight300,
  );

  static const darkColorSchemeTheme = ColorScheme.dark(
    primary: HighlightColors.highlight500,
    onPrimary: NeutralColors.dark500,
    surface: NeutralColors.dark500,
    error: SupportColors.error300,
    onError: NeutralColors.dark500,
  );
}
