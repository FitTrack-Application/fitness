import 'package:flutter/material.dart';
import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';


class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final TextEditingController _recipeNameController = TextEditingController();
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
              // save logic
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
              controller: _recipeNameController,
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
                  onPressed: () {
                    // Navigate to food search screen and pick food
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeutralColors.light500),
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