import 'package:flutter/material.dart';

class StepOne extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;

  const StepOne({
    super.key,
    required this.nameController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey, // Associate the Form with the GlobalKey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('First, What can we call you?'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                // border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name cannot be empty";
                }
                return null; // Return null if the input is valid
              },
            ),
          ),
        ],
      ),
    );
  }
}
