import 'package:flutter/material.dart';
import 'package:mobile/cores/theme/widget_themes/bottom_navbar_theme.dart';
import 'package:mobile/cores/theme/widget_themes/card_theme.dart';
import 'package:mobile/cores/theme/widget_themes/color_scheme_theme.dart';
import 'package:mobile/cores/theme/widget_themes/elevated_button_theme.dart';
import 'package:mobile/cores/theme/widget_themes/outlined_button_theme.dart';
import 'package:mobile/cores/theme/widget_themes/radio_theme.dart';
import 'package:mobile/cores/theme/widget_themes/text_field_theme.dart';
import 'package:mobile/cores/theme/widget_themes/text_theme.dart';
import 'package:mobile/cores/theme/widget_themes/divider_theme.dart';
class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: TColorSchemeTheme.lightColorSchemeTheme,
    textTheme: TTextTheme.lightTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    //checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    radioTheme: TRadioTheme.lightRadioTheme,
    //scaffoldBackgroundColor: NeutralColors.light300,
    cardTheme: TCardTheme.lightCardTheme,
    bottomNavigationBarTheme: TBottomNavBarTheme.lightBottomNavBarTheme,
    dividerTheme: TDividerTheme.lightDividerTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: TColorSchemeTheme.darkColorSchemeTheme,
    textTheme: TTextTheme.darkTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
    //checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    radioTheme: TRadioTheme.darkRadioTheme,
    cardTheme: TCardTheme.darkCardTheme,
    bottomNavigationBarTheme: TBottomNavBarTheme.darkBottomNavBarTheme,
    dividerTheme: TDividerTheme.darkDividerTheme,
  );
}
