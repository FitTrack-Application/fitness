import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/list_item/list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    final profileViewModel = context.read<ProfileViewModel>();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 10),
              Consumer<ProfileViewModel>(
                builder: (context, profileViewModel, child) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        profileViewModel.userProfile.imageUrl.isNotEmpty
                            ? (profileViewModel.userProfile.imageUrl
                                        .startsWith('http')
                                    ? NetworkImage(
                                        profileViewModel.userProfile.imageUrl)
                                    : FileImage(File(
                                        profileViewModel.userProfile.imageUrl)))
                                as ImageProvider
                            : const AssetImage('assets/images/avatar.png'),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                  profileViewModel.userProfile.name.isNotEmpty
                      ? profileViewModel.userProfile.name
                      : "User Name",
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListItem(
                  leadingIcon: Icons.person,
                  title: "Profile",
                  onTap: () {
                    context.go('/profile/edit');
                  },
                ),
                ListItem(
                  leadingIcon: Icons.flag_outlined,
                  title: "Goals",
                  onTap: () {
                    context.go('/goal');
                  },
                ),
                ListItem(
                  leadingIcon: Icons.logout,
                  title: "Logout",
                  onTap: () async {
                    try {
                      // Call the logout method from AuthViewModel
                      await authViewModel.logout();
                      // Show a success message after logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logout successful")),
                      );
                      context.go(
                          '/welcome'); // Navigate to the welcome screen after logout
                    } catch (e) {
                      // Show an error message if logout fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Logout failed: $e")),
                      );
                    }
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
