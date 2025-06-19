import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class TBottomNavBarTheme {
  TBottomNavBarTheme._(); // Constructor private để ngăn khởi tạo

  static const lightBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: NeutralColors.light100, // Màu nền xanh đậm
    selectedItemColor: NeutralColors.dark500, // Màu icon/label khi được chọn
    unselectedItemColor: NeutralColors.light500, // Màu icon/label khi không được chọn
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, // Đảm bảo các item phân bố đều
  );

  static const darkBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: NeutralColors.dark500, // Màu nền đậm hơn cho dark theme
    selectedItemColor: NeutralColors.light100,
    unselectedItemColor: NeutralColors.dark200,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  );
}