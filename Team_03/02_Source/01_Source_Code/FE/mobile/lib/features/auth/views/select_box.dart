import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
class SelectBox<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const SelectBox({super.key, 
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: value == groupValue ? tPrimaryColor : Colors.transparent ,
          border: Border.all(
            color: value == groupValue ? Colors.transparent : tTextFieldColor,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: value == groupValue ? tDarkColor : tWhiteColor, // Change text color
              ),
            ),
          leading: Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: (T? newValue) {
              onChanged(newValue as T);
            },
          ),
        ),
      ),
    );
  }
}