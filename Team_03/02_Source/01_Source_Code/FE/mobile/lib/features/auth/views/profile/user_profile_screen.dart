import 'package:flutter/material.dart';
import 'package:mobile/features/auth/viewmodels/profile_viewmodel.dart';
import 'package:mobile/common/widgets/value_picker/value_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.fetchProfile(context);
    });

    return Scaffold(
      key: _scaffoldKey,
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
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      // Pick an image from the gallery
                      final XFile? pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        final File imageFile = File(pickedFile.path);

                        // Update the profile with the selected image
                        await profileViewModel.updateProfile(context,
                            imageFile: imageFile);

                        if (profileViewModel.hasError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(profileViewModel.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          // Update the avatar with the local file path
                          profileViewModel.userProfile.imageUrl =
                              imageFile.path;
                          profileViewModel.notifyListeners(); // Refresh the UI
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: profileViewModel
                                  .userProfile.imageUrl.isNotEmpty
                              ? (profileViewModel.userProfile.imageUrl
                                      .startsWith('http')
                                  ? NetworkImage(
                                      profileViewModel.userProfile.imageUrl)
                                  : FileImage(File(profileViewModel
                                      .userProfile.imageUrl))) as ImageProvider
                              : const AssetImage('assets/images/avatar.png'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username Section
                          // Name Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  final TextEditingController nameController =
                                      TextEditingController(
                                    text: profileViewModel.userProfile.name,
                                  );

                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Enter your name",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "Enter your name",
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final newName =
                                                nameController.text.trim();
                                            if (newName.isNotEmpty) {
                                              profileViewModel
                                                  .userProfile.name = newName;
                                              await profileViewModel
                                                  .updateProfile(context);

                                              if (profileViewModel.hasError) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        profileViewModel
                                                            .errorMessage),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Name updated successfully!"),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                              profileViewModel
                                                  .notifyListeners(); // Refresh the UI
                                            }
                                            Navigator.pop(
                                                context); // Close the modal
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  profileViewModel.userProfile.name.isNotEmpty
                                      ? profileViewModel.userProfile.name
                                      : "User Name",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Gender Section
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ValuePicker<String>(
                                    values: const ['Male', 'Female', 'Other'],
                                    initialValue:
                                        profileViewModel.userProfile.gender,
                                    onValueChanged: (newGender) {
                                      profileViewModel.userProfile.gender =
                                          newGender;
                                      profileViewModel.updateProfile(context);
                                      if (profileViewModel.hasError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                profileViewModel.errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
                                      if (profileViewModel.hasError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                profileViewModel.errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
                                      if (profileViewModel.hasError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                profileViewModel.errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
                                    values: const [
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
                                      if (profileViewModel.hasError) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                profileViewModel.errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
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
