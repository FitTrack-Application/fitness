import 'package:flutter/material.dart';

class FoodInfoSection extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const FoodInfoSection({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textTheme.bodyMedium),
            Text(value, style: textTheme.bodyMedium?.copyWith(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}