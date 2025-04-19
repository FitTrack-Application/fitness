import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/food.dart';
import '../../../viewmodels/diary_viewmodel.dart';

class FoodItemWidget extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  final String mealLogId;

  const FoodItemWidget({super.key, required this.food, required this.onTap, required this.mealLogId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final diaryViewModel = context.watch<DiaryViewModel>();
    final isAddingThisFood = diaryViewModel.isAddingFood(food.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      "${food.calories} cal, Carbs: ${food.carbs}g, Fat: ${food.fat}g, Protein: ${food.protein}g",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
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
              onTap: isAddingThisFood
                  ? null
                  : () {
                      diaryViewModel.addFoodToDiary(
                          mealLogId: mealLogId,
                          foodId: food.id,
                          servingUnit: 'GRAM',
                          numberOfServings: 100);
                    },
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
      ),
    );
  }
}
