import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/cores/constants/sizes.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String? label;
  final void Function() onPressed;
  final int? width;
  final TextStyle? textStyle;
  final Icon? icon;

  const ElevatedButtonCustom(
      {Key? key,
      this.label,
      required this.onPressed,
      this.width,
      this.textStyle,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: icon ?? SizedBox.shrink(),
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
        style: textStyle != null
            ? textStyle
            : Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
