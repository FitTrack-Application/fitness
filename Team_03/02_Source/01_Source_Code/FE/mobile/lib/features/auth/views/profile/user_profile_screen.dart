import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:mobile/common/widgets/value_picker/value_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.fetchProfile();
    });

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
            return Center(
                child: Text("Error: ${profileViewModel.errorMessage}"));
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
                          // Avatar Section
                          GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();

                              // Pick an image from the gallery
                              final XFile? pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);

                              if (pickedFile != null) {
                                final File imageFile = File(pickedFile.path);

                                // Update the profile with the selected image
                                await profileViewModel.updateProfile(context,
                                    imageFile: imageFile);

                                // Notify listeners to refresh the UI
                                profileViewModel.notifyListeners();
                              }
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
                                  backgroundImage: NetworkImage(
                                      profileViewModel.userProfile.imageUrl),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Username Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Username",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                profileViewModel.userProfile.name,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          const Divider(),

                          // Gender Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ValuePicker<String>(
                                    values: ['Male', 'Female', 'Other'],
                                    initialValue:
                                        profileViewModel.userProfile.gender,
                                    onValueChanged: (newGender) {
                                      profileViewModel.userProfile.gender =
                                          newGender;
                                      profileViewModel.updateProfile(context);
                                      profileViewModel
                                          .notifyListeners(); // Update the UI
                                    },
                                    displayText: (value) => value,
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
                                  profileViewModel.userProfile.gender,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Height Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ValuePicker<double>(
                                    values: List.generate(
                                        151, (index) => 100 + index.toDouble()),
                                    initialValue:
                                        profileViewModel.userProfile.height,
                                    onValueChanged: (newHeight) {
                                      profileViewModel.userProfile.height =
                                          newHeight;
                                      profileViewModel.updateProfile(context);
                                      profileViewModel
                                          .notifyListeners(); // Update the UI
                                    },
                                    displayText: (value) => "$value cm",
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
                                  "${profileViewModel.userProfile.height} cm",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Age Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ValuePicker<int>(
                                    values: List.generate(
                                        150, (index) => index + 1),
                                    initialValue:
                                        profileViewModel.userProfile.age,
                                    onValueChanged: (newAge) {
                                      profileViewModel.userProfile.age = newAge;
                                      profileViewModel.updateProfile(context);
                                      profileViewModel
                                          .notifyListeners(); // Update the UI
                                    },
                                    displayText: (value) => "$value years",
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
                                  "${profileViewModel.userProfile.age} years",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Activity Level Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ValuePicker<String>(
                                    values: [
                                      'Sedentary',
                                      'Light',
                                      'Moderate',
                                      'Active',
                                      'Very Active'
                                    ],
                                    initialValue: profileViewModel
                                        .userProfile.activityLevel,
                                    onValueChanged: (newActivityLevel) {
                                      profileViewModel.userProfile
                                          .activityLevel = newActivityLevel;
                                      profileViewModel.updateProfile(context);
                                      profileViewModel
                                          .notifyListeners(); // Update the UI
                                    },
                                    displayText: (value) => value,
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Activity Level",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  profileViewModel.userProfile.activityLevel,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
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
