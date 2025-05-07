import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/recipe.dart';
import '../../../viewmodels/diary_viewmodel.dart';

class RecipeItemWidget extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback? onAdd;

  const RecipeItemWidget({
    super.key,
    required this.recipe,
    required this.onTap,
    this.onAdd
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final diaryViewModel = context.watch<DiaryViewModel>();
    final isAddingThisFood = diaryViewModel.isAddingFood(recipe.id);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
              child: ListTile(
                onTap: onTap,
                contentPadding: const EdgeInsets.all(12),
                title: Text(recipe.name, style: theme.textTheme.titleMedium),
                subtitle: Text(
                  '${recipe.calories.toStringAsFixed(0)} kcal • '
                      '${recipe.protein.toStringAsFixed(1)}g P • '
                      '${recipe.carbs.toStringAsFixed(1)}g C • '
                      '${recipe.fat.toStringAsFixed(1)}g F',
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
