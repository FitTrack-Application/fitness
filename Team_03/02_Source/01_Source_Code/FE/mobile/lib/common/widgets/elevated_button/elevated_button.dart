import 'package:flutter/material.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String? label;
  final void Function() onPressed;
  final int? width;
  final TextStyle? textStyle;
  final Icon? icon;

  const ElevatedButtonCustom(
      {super.key,
      this.label,
      required this.onPressed,
      this.width,
      this.textStyle,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: icon ?? const SizedBox.shrink(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Custom rounded border
        ),
        //backgroundColor: tSecondaryColor, // Optional: Set a custom background color
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 24.0), // Optional: Add padding
      ),
      label: Text(
        label!,
        style: textStyle ?? Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
