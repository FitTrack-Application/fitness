import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile'); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                color: NeutralColors.dark400,
                borderRadius: BorderRadius.circular(8.0),        
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Username",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "vinh123", 
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Avatar",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Height",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                    "170 cm", 
                    style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Sex",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                    "Male", 
                    style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Age",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                    "22", 
                    style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                    "abc@gmail.com", 
                    style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.go('/goal'); // Navigate to the /goal route
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Goal",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Edit goal",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),           
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}