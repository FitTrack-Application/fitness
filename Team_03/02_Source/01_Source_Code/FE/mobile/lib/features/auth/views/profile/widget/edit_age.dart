import 'package:flutter/material.dart';

class EditAge extends StatefulWidget {
  final int initialAge;
  final ValueChanged<int> onAgeChanged;

  const EditAge({
    super.key,
    required this.initialAge,
    required this.onAgeChanged,
  });

  @override
  _EditAgeState createState() => _EditAgeState();
}

class _EditAgeState extends State<EditAge> {
  late int selectedAge;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectedAge = widget.initialAge;

    // Initialize the scroll controller to start at the initial age
    scrollController = FixedExtentScrollController(initialItem: widget.initialAge - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300, // Set a fixed height for the modal
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: scrollController,
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedAge = index + 1; // Age range: 1 to 150
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final age = index + 1; // Age range: 1 to 150
                  return Center(
                    child: Text(
                      '$age',
                      style: selectedAge == age
                          ? Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )
                          : Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
                childCount: 150, // 1 to 150 (inclusive)
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onAgeChanged(selectedAge);
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}