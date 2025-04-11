import 'package:flutter/material.dart';

class StepOne extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onNameChanged; 

  const StepOne({
    super.key,
    required this.nameController,
    required this.formKey,
    required this.onNameChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('First, What can we call you?'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
              ),
              onChanged: onNameChanged, 
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Name cannot be empty";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
