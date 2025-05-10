import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TDividerTheme {
  TDividerTheme._();

  static const lightDividerTheme = DividerThemeData(
    color: NeutralColors.dark200,
    thickness: 0.3,
    space: 16.0,
    indent: 0.0,
    endIndent: 0.0,
  );

  static const darkDividerTheme = DividerThemeData(
    color: NeutralColors.light400,
    thickness: 0.3,
    space: 16.0,
    indent: 0.0,
    endIndent: 0.0,
  );

}