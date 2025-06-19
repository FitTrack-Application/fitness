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
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender; // Set the initial gender
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300, // Set a fixed height for the modal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedGender = genders[index];
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      genders[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedGender == genders[index]
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: selectedGender == genders[index]
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                  );
                },
                childCount: genders.length,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
