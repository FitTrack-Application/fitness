import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:go_router/go_router.dart';
class GoalPage extends StatelessWidget {
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
              color: tLightDarkColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
                ),
              ],
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                  "Starting Weight",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                  "70 kg (26/03/2025)", // Example placeholder text
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                ),
                const SizedBox(height: 16),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                  "Current Weight",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                  "68 kg (26/04/2025)", // Example placeholder text
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                ),
                const SizedBox(height: 16),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                  "Goal Weight",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                  "65 kg (26/06/2025)", // Example placeholder text
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                ),
                const SizedBox(height: 16),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                  "Weekly Goal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                  "Lose 0.5 kg per week", // Example placeholder text
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
                ),
                const SizedBox(height: 16),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                  "Activity Level",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                  "Moderate Activity", // Example placeholder text
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
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