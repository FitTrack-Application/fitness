import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';
import '../../models/recipe.dart';


class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeDescriptionController = TextEditingController();
  List<Food> selectedFoods = [];

  void _addFood(Food food) {
    setState(() {
      selectedFoods.add(food);
    });
  }

  void _removeFood(Food food) {
    setState(() {
      selectedFoods.remove(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () {
              final name = _recipeNameController.text.trim();
              final description = _recipeDescriptionController.text.trim(); // You'll want a separate controller for this!

              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a recipe name.')),
                );
                return;
              }

              if (selectedFoods.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one ingredient.')),
                );
                return;
              }

              double totalCalories = 0;
              double totalProtein = 0;
              double totalCarbs = 0;
              double totalFat = 0;

              for (var food in selectedFoods) {
                totalCalories += food.calories;
                totalProtein += food.protein;
                totalCarbs += food.carbs;
                totalFat += food.fat;
              }

              final recipe = Recipe(
                id: UniqueKey().toString(), // or generate UUID
                name: name,
                description: description,
                servingSize: 100.0,
                unit: 'grams',
                calories: totalCalories,
                protein: totalProtein,
                carbs: totalCarbs,
                fat: totalFat,
                foodList: selectedFoods,
              );
              onRecipeCreated(Recipe recipe) async {
                // Navigate to the detail screen
                await context.push('/recipe_detail', extra: recipe);

                // Then return the recipe to previous screen (e.g., after viewing/editing)
                context.pop(recipe);
              }
              onRecipeCreated(recipe);
            },
            child: const Text('Save', style: TextStyle(color: HighlightColors.highlight500)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _recipeNameController,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _recipeDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton(
                  onPressed: () async {
                    final food = await context.push<Food>('/search_food_for_recipe');
                    if (food != null) {
                      _addFood(food);
                    }
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
              child: selectedFoods.isEmpty
                  ? Center(
                child: Text('No ingredients yet.', style: Theme.of(context).textTheme.bodyLarge),
              )
                  : ListView.builder(
                itemCount: selectedFoods.length,
                itemBuilder: (context, index) {
                  final food = selectedFoods[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: NeutralColors.light100,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      title: Text(food.name, style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text(
                        '${food.calories.toStringAsFixed(0)} kcal - ${food.protein}g P / ${food.carbs}g C / ${food.fat}g F',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeutralColors.dark100),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AccentColors.red300),
                        onPressed: () => _removeFood(food),
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