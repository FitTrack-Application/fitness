import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: ElevatedButton(
          child: Text("Dashboard Click Me",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
          onPressed: () {
            GoRouter.of(context).push('/welcome');
          },
        ),
      ),
    );
  }
}
