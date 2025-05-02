import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/food.dart';
import '../../../viewmodels/diary_viewmodel.dart';

class FoodItemWidget extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  final VoidCallback? onAdd; // <-- New optional onAdd callback

  const FoodItemWidget({
    super.key,
    required this.food,
    required this.onTap,
    this.onAdd, // <-- Accept from parent
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final diaryViewModel = context.watch<DiaryViewModel>();
    final isAddingThisFood = diaryViewModel.isAddingFood(food.id);

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                onTap: onTap,
                contentPadding: const EdgeInsets.all(12),
                title: Text(food.name, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${food.calories.toStringAsFixed(0)} kcal • '
                      '${food.protein.toStringAsFixed(1)}g P • '
                      '${food.carbs.toStringAsFixed(1)}g C • '
                      '${food.fat.toStringAsFixed(1)}g F',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: isAddingThisFood ? null : onAdd, // <- Use the custom callback
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isAddingThisFood
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  )
                      : Icon(Icons.add, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ],
        )
    );
  }
}


