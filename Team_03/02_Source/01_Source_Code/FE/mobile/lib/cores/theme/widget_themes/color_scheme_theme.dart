import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TColorSchemeTheme {
  TColorSchemeTheme._();

  static final lightColorSchemeTheme = ColorScheme.light(
    primary: HighlightColors.highlight500,
    onPrimary: NeutralColors.light100,
    background: NeutralColors.light100,
    surface: NeutralColors.light200,
    error: SupportColors.error300,
    onError: NeutralColors.light100,

  );

  static final darkColorSchemeTheme = ColorScheme.dark(
      primary: HighlightColors.highlight500,
      onPrimary: NeutralColors.dark500,
      background: NeutralColors.dark500,
      surface: NeutralColors.dark500,
      error: SupportColors.error300,
      onError: NeutralColors.dark500,
  );
}
