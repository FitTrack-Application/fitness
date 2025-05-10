import 'dart:ui';
import 'package:flutter/material.dart';

// Highlight Colors (Xanh dương)
class HighlightColors {
  static const Color highlight500 = Color(0xFF006FFD); // Màu primary trong light Theme
  static const Color highlight400 = Color(0xFF2897FF); // Màu primary trong dark Theme
  static const Color highlight300 = Color(0xFF6FBAFF); // Nhạt hơn nữa
  static const Color highlight200 = Color(0xFFB4DBFF); // Rất nhạt
  static const Color highlight100 = Color(0xFFEAF2FF); // Gần trắng
}

class AccentColors {
  static const Color red300 = Color(0xFFED3861);
  static const Color red200 = Color(0xFFFD7695);
  static const Color red100 = Color(0xFFFFBED7);

  static const Color yellow300 = Color(0xFFF5A524);
  static const Color yellow200 = Color(0xFFFFCD79);
  static const Color yellow100 = Color(0xFFFFE7C3);
}

class TonalButtonColors {
  static const Color primary = Color(0x22006FFD); // Màu chính
  static const Color onPrimary = Color(0xFF006FFD);
}

class NutritionColor {
  static const Color cabs = Color(0xFF14B8A6);
  static const Color fat = Color(0xFFD8325D);
  static const Color protein = Color(0xFFFFB02A);
}

// Neutral Colors (Các màu trung tính)
class NeutralColors {
  // Light
  static const Color light500 = Color(0xFFC5C6CC); // Xám trung bình
  static const Color light400 = Color(0xFFD4D6DD); // Nhạt hơn
  static const Color light300 = Color(0xFFEDEDF6); // Nhạt hơn nữa
  static const Color light200 = Color(0xFFF8F9FE); // Rất nhạt và là màu background trong Light Theme
  static const Color light100 = Color(0xFFFFFFFF); // Trắng và là màu background cho các Card ở Light Theme

  // Dark
  static const Color dark500 = Color(0xFF121620); // Đậm nhất và là màu background trong Dark Theme
  static const Color dark400 = Color(0xFF252E37); // Đậm vừa và là màu background cho các Card ở Dark Theme
  static const Color dark300 = Color(0xFF353F54); // Trung bình
  static const Color dark200 = Color(0xFF60647A); // Nhạt hơn
  static const Color dark100 = Color(0xFF83869F); // Nhạt nhất
}

// Support Colors (Màu hỗ trợ thêm)
class SupportColors {
  // Success
  static const Color success300 = Color(0xFF298267); // Đậm nhất
  static const Color success200 = Color(0xFF3AC0A0); // Trung bình
  static const Color success100 = Color(0xFFE7F4E8); // Nhạt nhất

  // Warning
  static const Color warning300 = Color(0xFFE86339); // Đậm nhất
  static const Color warning200 = Color(0xFFFFB37C); // Trung bình
  static const Color warning100 = Color(0xFFFFF4E4); // Nhạt nhất

  // Error
  static const Color error300 = Color(0xFFED3241); // Đậm nhất
  static const Color error200 = Color(0xFFFF616D); // Trung bình
  static const Color error100 = Color(0xFFFFE2E5); // Nhạt nhất
}
class SurfaceColors {
  static const Color surface100 = Color(0x22E8E9F1); // Nhạt nhất
}