import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddStep extends StatelessWidget {
  const AddStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add step"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard'); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check), // Confirm button icon
            onPressed: () {
              context.go('/dashboard');
            },
          ),
        ],
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
                          "Steps",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "70",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "20/04/2025",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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