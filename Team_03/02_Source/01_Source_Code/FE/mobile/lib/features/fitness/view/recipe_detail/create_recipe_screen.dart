import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/models/meal_log.dart';
import 'package:provider/provider.dart';
import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';
import '../../models/serving_unit.dart';
import '../../services/repository/recipe_repository.dart';
import '../../viewmodels/create_recipe_viewmodel.dart';

class CreateRecipeScreen extends StatelessWidget {
  final String mealogId;
  final MealType mealType;
  const CreateRecipeScreen({
    super.key,
    required this.mealType,
    required this.mealogId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRecipeViewModel(RecipeRepository()),
      child: _CreateRecipeScreenContent(
        mealogId: mealogId,
        mealType: mealType,
      ),
    );
  }
}


class _CreateRecipeScreenContent extends StatelessWidget {
  final String mealogId;
  final MealType mealType;

  const _CreateRecipeScreenContent({
    required this.mealogId,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateRecipeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () async {
              final recipe = await viewModel.createRecipe();
              if (recipe == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to create recipe.')),
                );
                return;
              }
              await context.push(
                '/recipe_detail/$mealogId?mealType=${mealTypeToString(mealType)}',
                extra: recipe,
              );
              context.pop(recipe);
              // Save and pop
              Navigator.pop(context, recipe);
                        },
            child: const Text('Save', style: TextStyle(color: HighlightColors.highlight500)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModel.nameController,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: viewModel.descriptionController,
              decoration: InputDecoration(
                labelText: 'Direction',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            // viewModel.isLoadingUnits
            //     ? const CircularProgressIndicator()
            //     : DropdownButtonFormField<ServingUnit>(
            //   value: viewModel.selectedUnit, // vm.selectedUnit must now be nullable
            //   items: viewModel.servingUnits.map((unit) {
            //     return DropdownMenuItem<ServingUnit>(
            //       value: unit,
            //       child: Text('${unit.unitName} (${unit.unitSymbol})'),
            //     );
            //   }).toList(),
            //   onChanged: (unit) {
            //     if (unit != null) {
            //       viewModel.setSelectedUnit(unit);
            //     }
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Serving Unit',
            //     labelStyle: Theme.of(context).textTheme.bodyLarge, // match label font
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            //   ),
            //   style: Theme.of(context).textTheme.bodyLarge, // controls selected text style
            //   dropdownColor: NeutralColors.light100, // optional: matches card theme
            // ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton(
                  onPressed: () async {
                    final food = await context.push<Food>('/search_food_for_recipe');
                    if (food != null) viewModel.addFood(food);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TonalButtonColors.primary,
                    foregroundColor: TonalButtonColors.onPrimary,
                  ),
                  child: const Text('+ Add Food'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: viewModel.selectedFoods.isEmpty
                  ? const Center(child: Text('No ingredients yet.'))
                  : ListView.builder(
                itemCount: viewModel.selectedFoods.length,
                itemBuilder: (_, index) {
                  final food = viewModel.selectedFoods[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: NeutralColors.light100,
                    child: ListTile(
                      title: Text(food.name),
                      subtitle: Text('${food.calories} kcal • ${food.protein}g P / ${food.carbs}g C / ${food.fat}g F'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AccentColors.red300),
                        onPressed: () => viewModel.removeFood(food),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
