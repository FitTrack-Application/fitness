import 'package:flutter/material.dart';
import 'package:mobile/cores/theme/widget_themes/select_box_theme.dart';

class SelectBox<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const SelectBox({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        decoration: SelectBoxTheme.containerDecoration(
          context,
          isSelected,
        ),
        child: ListTile(
          title: Text(
            title,
            style: SelectBoxTheme.labelTextBoxStyle(context),
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
