import 'package:flutter/material.dart';

class EditGender extends StatefulWidget {
  final String initialGender;
  final ValueChanged<String> onGenderChanged;

  const EditGender({
    super.key,
    required this.initialGender,
    required this.onGenderChanged,
  });

  @override
  _EditGenderState createState() => _EditGenderState();
}

class _EditGenderState extends State<EditGender> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender; // Set the initial gender
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 250, // Set a fixed height for the modal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              widget.onGenderChanged(selectedGender);
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}