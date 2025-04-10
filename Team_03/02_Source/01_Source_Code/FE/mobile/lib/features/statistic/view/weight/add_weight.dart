import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';

class AddWeight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add weight"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard'); // Navigate back to the previous screen
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                  ? NeutralColors.dark400 
                  : NeutralColors.light400, 
                borderRadius: BorderRadius.circular(8.0),        
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Weight",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "70", 
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                    "20/04/2025", 
                    style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    "Progress photo",
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                    )
                  ],
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