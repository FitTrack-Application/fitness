import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: ElevatedButtonCustom(
          text: "Dashboard Click Me",
          onPressed: () {
            print("Button Pressed");
          },
        ),
      ),
    );
  }
}
