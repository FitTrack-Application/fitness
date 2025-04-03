import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/cores/constants/sizes.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final int? width;
  final TextStyle? textStyle;


  const ElevatedButtonCustom({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.textStyle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Custom rounded border
        ),
        //backgroundColor: tSecondaryColor, // Optional: Set a custom background color
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0), // Optional: Add padding
      ),
      child: Text(
        text,
        style: textStyle != null ? textStyle : Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}