import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(child: Text("User Profile Screen")),
    );
  }
}
