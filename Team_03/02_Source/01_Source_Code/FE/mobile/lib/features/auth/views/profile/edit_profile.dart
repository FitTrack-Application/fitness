import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
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
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage('https://example.com/avatar.jpg'),
                        )
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
                          "vinh123",
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
                          "170 cm",
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
                          "Male",
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
                          "22",
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
                          "abc@gmail.com",
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
                      alignment: Alignment.centerLeft, // Align the content to the left
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Ensure children are aligned to the start
                        children: [
                          Text(
                            "Goal",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "Edit weight,goal",
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
      ),
    );
  }
}