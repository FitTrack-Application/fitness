import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class TCardTheme {
  TCardTheme._(); // Constructor private để ngăn khởi tạo

  static final lightCardTheme = CardTheme(
    elevation: 0.2, // Không có bóng
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Bo góc 12
    ),
    color: NeutralColors.light100, // Nền trong hơn (light theme)
    margin: const EdgeInsets.all(0), // Margin mặc định
  );

  static final darkCardTheme = CardTheme(
    elevation: 1, // Không có bóng
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Bo góc 12
    ),
    color: NeutralColors.dark400, // Nền trong hơn (dark theme)
    margin: const EdgeInsets.all(0), // Margin mặc định
  );
}