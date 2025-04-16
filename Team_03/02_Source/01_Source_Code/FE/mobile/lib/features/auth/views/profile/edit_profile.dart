import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.fetchProfile(); // Fetch profile data when the screen is built

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          if (profileViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileViewModel.hasError) {
            return Center(child: Text("Error: ${profileViewModel.errorMessage}"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Avatar",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(profileViewModel.imageURL),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Username",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                profileViewModel.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Height",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "${profileViewModel.height} cm",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sex",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                profileViewModel.gender,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Age",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                "${profileViewModel.age}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                profileViewModel.email,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              context.go('/goal'); // Navigate to the /goal route
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Goal",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    "Edit weight, goal",
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}