import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';

class TonalButton extends StatelessWidget {
  final String? label;
  final void Function() onPressed;
  final int? width;
  final TextStyle? textStyle;
  final IconData? icon;

  const TonalButton({
    super.key,
    this.label,
    required this.onPressed,
    this.width,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIconOnly = icon != null && (label == null || label!.isEmpty);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: TonalButtonColors.primary,
      foregroundColor: HighlightColors.highlight500,
      elevation: 0, // Loại bỏ đổ bóng
      shape: isIconOnly
          ? const CircleBorder(
              side: BorderSide(width: 0)) // Hình tròn cho nút chỉ có icon
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
      padding: isIconOnly
          ? const EdgeInsets.all(10) // Padding cho nút hình tròn
          : const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
    );

    final Widget button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(
              icon,
              size: 24,
              //color: Theme.of(context).colorScheme.onPrimary,
            )
          : const SizedBox.shrink(),
      style: buttonStyle,
      label: isIconOnly
          ? const SizedBox.shrink() // Ẩn label nếu chỉ có icon
          : Text(
              label ?? "",
              style: textStyle ?? Theme.of(context).textTheme.labelSmall,
            ),
    );

    // Chỉ áp dụng width nếu không phải nút hình tròn
    if (width != null && !isIconOnly) {
      return SizedBox(width: width!.toDouble(), child: button);
    }

    return button;
  }
}
