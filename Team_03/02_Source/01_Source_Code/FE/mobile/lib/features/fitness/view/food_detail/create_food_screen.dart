import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/models/meal_log.dart';
import 'package:mobile/features/fitness/viewmodels/create_food_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../../../cores/constants/colors.dart';
import '../../models/serving_unit.dart';
import '../../services/repository/food_repository.dart';

class CreateFoodScreen extends StatelessWidget {
  final String mealogId;
  final MealType mealType;
  const CreateFoodScreen({
    super.key,
    required this.mealType,
    required this.mealogId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateFoodViewmodel(FoodRepository())..loadServingUnits(),
      child: _CreateFoodScreenContent(
        mealogId: mealogId,
        mealType: mealType,
      ),
    );
  }
}

class _CreateFoodScreenContent extends StatelessWidget {
  final String mealogId;
  final MealType mealType;

  const _CreateFoodScreenContent({
    required this.mealogId,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateFoodViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Food', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () async {
              final food = await viewModel.createFood();
              if (food == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to create food.')),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Food created successfully'),
                  backgroundColor: Colors.cyan,
                ),
              );
              await context.push('/food/${mealogId}/${food.id}/add/100?mealType=${mealTypeToString(mealType)}');
              context.pop(food);
              // Save and pop
              Navigator.pop(context, food);
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
                labelText: 'Food Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: viewModel.caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: viewModel.proteinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Proteins',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: viewModel.carbController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Carbs',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: viewModel.fatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Fats',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
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
                labelStyle: Theme.of(context).textTheme.bodyLarge, // match label font
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: Theme.of(context).textTheme.bodyLarge, // controls selected text style
              dropdownColor: NeutralColors.light100, // optional: matches card theme
            ),
            const SizedBox(height: 10),
            TextField(
              controller: viewModel.numberOfServingsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number Of Servings',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
