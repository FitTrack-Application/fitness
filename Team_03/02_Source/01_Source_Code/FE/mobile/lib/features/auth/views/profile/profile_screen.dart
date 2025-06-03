import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/list_item/list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

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
              CircleAvatar(
                radius: 40,
                backgroundImage: Provider.of<ProfileViewModel>(context,
                            listen: false)
                        .userProfile
                        .imageUrl
                        .isNotEmpty
                    ? NetworkImage(
                        Provider.of<ProfileViewModel>(context, listen: false)
                            .userProfile
                            .imageUrl)
                    : const AssetImage('assets/images/avatar.png')
                        as ImageProvider,
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
                  leadingIcon: Icons.lock,
                  title: "Change Password",
                  onTap: () {
                    // Navigate to Change Password Page
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
