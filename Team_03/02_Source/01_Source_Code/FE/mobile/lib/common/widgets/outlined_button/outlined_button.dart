import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';


class OutlinedButtonCustom extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Image? icon; // Thay đổi thành Image? để có thể null

  const OutlinedButtonCustom({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon, // Icon không bắt buộc
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon ??
          const SizedBox.shrink(), // Nếu không có icon, sử dụng SizedBox.shrink()
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        foregroundColor: NeutralColors.dark400,
        backgroundColor: NeutralColors.light200,
        side: const BorderSide(color: NeutralColors.dark500),
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 24.0), // Optional: Add padding
      ),
      onPressed: onPressed,
      label: Text(label),
    );
  }
}
