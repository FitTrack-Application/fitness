import 'package:flutter/material.dart';

class EditHeight extends StatefulWidget {
  final double initialHeight;
  final ValueChanged<double> onHeightChanged;

  const EditHeight({
    super.key,
    required this.initialHeight,
    required this.onHeightChanged,
  });

  @override
  _EditHeightState createState() => _EditHeightState();
}

class _EditHeightState extends State<EditHeight> {
  late double selectedHeight;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectedHeight = widget.initialHeight;

    // Calculate the initial index based on the initial height
    final initialIndex = (widget.initialHeight - 100).toInt();
    scrollController = FixedExtentScrollController(initialItem: initialIndex);
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
              controller: scrollController, // Use the scroll controller
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHeight = 100 + index.toDouble(); // Height range: 100-250 cm
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final height = 100 + index; // Height range: 100-250 cm
                  return Center(
                    child: Text(
                      '$height cm',
                      style: selectedHeight == height.toDouble()
                          ? Theme.of(context).textTheme.displaySmall
                          : Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
                childCount: 151, // 100 to 250 cm (inclusive)
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onHeightChanged(selectedHeight);
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}