import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:mobile/common/widgets/list_item/list_item.dart';
import 'package:go_router/go_router.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
            Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              GestureDetector(
                onTap: () {
                context.go('/profile/edit');
                },
                child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[700],
                ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "user@example.com",
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                ),
              ),
              ],
            ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListItem(
                    leadingIcon: Icons.flag_outlined,
                  title: "Goals",
                  onTap: () {
                    context.go('/goal');
                  },
                ),
                ListItem(
                  leadingIcon: Icons.lock,
                  title: "Change Password",
                  onTap: () {
                    // Navigate to Change Password Page
                  },
                ),
                ListItem(
                  leadingIcon: Icons.logout,
                  title: "Logout",
                  onTap: () {
                    // Handle Logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
