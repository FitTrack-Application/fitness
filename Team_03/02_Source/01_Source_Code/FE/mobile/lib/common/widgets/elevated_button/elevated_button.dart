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
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Text(text));
  }
}