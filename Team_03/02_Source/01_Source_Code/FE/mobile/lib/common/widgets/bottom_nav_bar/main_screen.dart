import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Hiển thị màn hình hiện tại
      bottomNavigationBar: BottomNavBar(), // BottomNav luôn giữ nguyên
    );
  }
}
