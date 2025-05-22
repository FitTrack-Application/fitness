import 'package:flutter/material.dart';

class ValuePicker<T> extends StatefulWidget {
  final List<T> values;
  final T initialValue;
  final ValueChanged<T> onValueChanged;
  final String Function(T value) displayText;

  const ValuePicker({
    super.key,
    required this.values,
    required this.initialValue,
    required this.onValueChanged,
    required this.displayText,
  });

  @override
  _ValuePickerState<T> createState() => _ValuePickerState<T>();
}

class _ValuePickerState<T> extends State<ValuePicker<T>> {
  late T selectedValue;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;

    // Calculate the initial index based on the initial value
    final initialIndex = widget.values.indexOf(widget.initialValue);
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
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: scrollController,
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedValue = widget.values[index];
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final value = widget.values[index];
                  return Center(
                    child: Text(
                      widget.displayText(value),
                      style: selectedValue == value
                          ? Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              )
                          : Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
                childCount: widget.values.length,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onValueChanged(selectedValue);
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
