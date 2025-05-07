import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:mobile/features/auth/views/profile/widget/edit_gender.dart';
import 'package:mobile/features/auth/views/profile/widget/edit_avatar.dart';
import 'package:mobile/features/auth/views/profile/widget/edit_height.dart';
import 'package:mobile/features/auth/views/profile/widget/edit_age.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) {
                                  return EditAvatar(
                                    initialAvatarUrl: profileViewModel.imageURL,
                                    onAvatarChanged: (newAvatar) {
                                      if (newAvatar != null) {
                                        profileViewModel.imageURL = newAvatar.path;
                                        profileViewModel.notifyListeners(); // Update the UI
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
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
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) {
                                  return EditGender(
                                    initialGender: profileViewModel.gender,
                                    onGenderChanged: (newGender) {
                                      profileViewModel.gender = newGender;
                                      profileViewModel.notifyListeners(); // Update the UI
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gender",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  profileViewModel.gender,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) {
                                  return EditHeight(
                                    initialHeight: profileViewModel.height,
                                    onHeightChanged: (newHeight) {
                                      profileViewModel.height = newHeight;
                                      profileViewModel.notifyListeners(); // Update the UI
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
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
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) {
                                  return EditAge(
                                    initialAge: profileViewModel.age,
                                    onAgeChanged: (newAge) {
                                      profileViewModel.age = newAge;
                                      profileViewModel.notifyListeners(); // Update the UI
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Age",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  "${profileViewModel.age} years",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
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