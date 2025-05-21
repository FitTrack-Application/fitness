import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Diary")),
      body: Center(child: Text("Fitness Diary Screen")),
    );
  }
}
