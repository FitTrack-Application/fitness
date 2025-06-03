// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:dio/dio.dart';
// import 'package:mobile/cores/utils/dio/dio_client.dart';
// import 'package:mobile/features/fitness/services/repository/serving_unit_repository.dart';
//
// import '../../../../cores/constants/colors.dart';
// import '../../models/food.dart';
// import '../../models/recipe.dart';
// import '../../models/serving_unit.dart';
//
// class CreateRecipeScreen extends StatefulWidget {
//   const CreateRecipeScreen({super.key});
//
//   @override
//   State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
// }
//
// class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
//   final TextEditingController _recipeNameController = TextEditingController();
//   final TextEditingController _recipeDescriptionController = TextEditingController();
//
//
//   List<Food> selectedFoods = [];
//   List<ServingUnit> servingUnits = [];
//   ServingUnit? selectedUnit;
//   bool isLoadingUnits = true;
//
//
//   void _addFood(Food food) {
//     setState(() {
//       selectedFoods.add(food);
//     });
//   }
//
//   void _removeFood(Food food) {
//     setState(() {
//       selectedFoods.remove(food);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Recipe', style: Theme.of(context).textTheme.titleLarge),
//         actions: [
//           TextButton(
//             onPressed: () {
//               final name = _recipeNameController.text.trim();
//               final description = _recipeDescriptionController.text.trim();
//
//               if (name.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please enter a recipe name.')),
//                 );
//                 return;
//               }
//
//               if (selectedFoods.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please add at least one ingredient.')),
//                 );
//                 return;
//               }
//
//               if (selectedUnit == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please select a serving unit.')),
//                 );
//                 return;
//               }
//
//               final recipe = Recipe(
//                 id: UniqueKey().toString(),
//                 name: name,
//                 description: description,
//                 numberOfServings: 100.0,
//                 servingUnit: selectedUnit!,
//                 foodList: selectedFoods,
//               );
//
//               onRecipeCreated(Recipe recipe) async {
//                 await context.push('/recipe_detail', extra: recipe);
//                 context.pop(recipe);
//               }
//
//               onRecipeCreated(recipe);
//             },
//             child: const Text('Save', style: TextStyle(color: HighlightColors.highlight500)),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _recipeNameController,
//               decoration: InputDecoration(
//                 labelText: 'Recipe Name',
//                 labelStyle: Theme.of(context).textTheme.bodyMedium,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _recipeDescriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Description',
//                 labelStyle: Theme.of(context).textTheme.bodyMedium,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             isLoadingUnits
//                 ? const Center(child: CircularProgressIndicator())
//                 : DropdownButtonFormField<ServingUnit>(
//               value: selectedUnit,
//               decoration: InputDecoration(
//                 labelText: 'Serving Unit',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               items: servingUnits.map((unit) {
//                 return DropdownMenuItem<ServingUnit>(
//                   value: unit,
//                   child: Text('${unit.unitName} (${unit.unitSymbol})'),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() => selectedUnit = value);
//               },
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final food = await context.push<Food>('/search_food_for_recipe');
//                     if (food != null) {
//                       _addFood(food);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: TonalButtonColors.primary,
//                     foregroundColor: TonalButtonColors.onPrimary,
//                   ),
//                   child: const Text('+ Add Food'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: selectedFoods.isEmpty
//                   ? Center(
//                 child: Text('No ingredients yet.', style: Theme.of(context).textTheme.bodyLarge),
//               )
//                   : ListView.builder(
//                 itemCount: selectedFoods.length,
//                 itemBuilder: (context, index) {
//                   final food = selectedFoods[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 6),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     color: NeutralColors.light100,
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(12),
//                       title: Text(food.name, style: Theme.of(context).textTheme.titleSmall),
//                       subtitle: Text(
//                         '${food.calories.toStringAsFixed(0)} kcal - ${food.protein}g P / ${food.carbs}g C / ${food.fat}g F',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(color: NeutralColors.dark100),
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: AccentColors.red300),
//                         onPressed: () => _removeFood(food),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';
import '../../models/serving_unit.dart';
import '../../services/repository/recipe_repository.dart';
import '../../viewmodels/create_recipe_viewmodel.dart';

class CreateRecipeScreen extends StatelessWidget {
  const CreateRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRecipeViewModel(RecipeRepository())..loadServingUnits(),
      child: const _CreateRecipeScreenContent(),
    );
  }
}


class _CreateRecipeScreenContent extends StatelessWidget {
  const _CreateRecipeScreenContent();

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
              await context.push('/recipe_detail', extra: recipe);
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
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: viewModel.numberOfServingsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Servings',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            viewModel.isLoadingUnits
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<ServingUnit>(
              value: viewModel.selectedUnit, // vm.selectedUnit must now be nullable
              items: viewModel.servingUnits.map((unit) {
                return DropdownMenuItem<ServingUnit>(
                  value: unit,
                  child: Text('${unit.unitName} (${unit.unitSymbol})'),
                );
              }).toList(),
              onChanged: (unit) {
                if (unit != null) {
                  viewModel.setSelectedUnit(unit);
                }
              },
              decoration: InputDecoration(
                labelText: 'Serving Unit',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
