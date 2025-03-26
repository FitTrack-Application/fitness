import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/cores/constants/sizes.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const ElevatedButtonCustom({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Custom rounded border
        ),
        backgroundColor: tSecondaryColor, // Optional: Set a custom background color
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Optional: Add padding
      ),
      child: Text(
        text,
        style: const TextStyle(color: tWhiteColor), // Optional: Set text color
      ),
    );
  }
}