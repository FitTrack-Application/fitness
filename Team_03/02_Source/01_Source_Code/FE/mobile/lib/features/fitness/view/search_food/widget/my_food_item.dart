import 'package:flutter/material.dart';
import 'package:mobile/features/fitness/viewmodels/search_food_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../models/food.dart';
import '../../../viewmodels/diary_viewmodel.dart';

class MyFoodItemWidget extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  final VoidCallback? onAdd;// <-- New optional onAdd callback
  final VoidCallback? onRemove;

  const MyFoodItemWidget({
    super.key,
    required this.food,
    required this.onTap,
    this.onAdd, // <-- Accept from parent
    this.onRemove,
  });



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final diaryViewModel = context.watch<DiaryViewModel>();
    final foodViewmodel = context.watch<SearchFoodViewModel>();
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
                  '${food.calories.toStringAsFixed(0)} cal • '
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
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("CONFIRM DELETE"),
                      content: const Text("Are you sure you want to delete this food?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();// Close dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 16),
                                    Text("Deleting..."),
                                  ],
                                ),
                              ),
                            );
                            bool isDeleted = await foodViewmodel.removeFood(food);
                            Navigator.of(context).pop();
                            if(isDeleted){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => AlertDialog(
                                    title: const Text("FOOD DELETED"),
                                    content: const Text("The food is deleted succesfully"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                        {
                                          Navigator.of(ctx).pop(),
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ]
                                ),
                              );
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to delete food.")),
                              );
                            }
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                }, // <- Use the custom callback
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isAddingThisFood
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.red,
                    ),
                  )
                      : Icon(Icons.delete, color: colorScheme.onPrimaryContainer),
                ),
              ),
            ),
          ],
        )
    );
  }
}


