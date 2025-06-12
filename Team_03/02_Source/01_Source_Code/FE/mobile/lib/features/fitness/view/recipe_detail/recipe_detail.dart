import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/features/fitness/services/repository/recipe_repository.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/calorie_summary.dart';
import 'package:mobile/features/fitness/viewmodels/recipe_detail_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';
import '../../models/meal_log.dart';
import '../../models/recipe.dart';


class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final MealType mealType;
  final String mealLogId;
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.mealType,
    required this.mealLogId,
  });

  @override
  State<StatefulWidget> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetailScreen> {
  late final RecipeDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RecipeDetailViewModel(
      recipe: widget.recipe,
      repository: RecipeRepository(),
      mealLogId: widget.mealLogId,
    );
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeDetailViewModel>(
      create: (_) => viewModel,
      child: Consumer<RecipeDetailViewModel>(
        builder: (context, viewModel, child) {
          final recipe = viewModel.recipe;
          return Scaffold(
            appBar: AppBar(
              title: Text(recipe.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              backgroundColor: HighlightColors.highlight500,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description (if available)
                  if (recipe.name.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Direction",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),

                  if (recipe.direction.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        recipe.direction,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),

                  // Nutrition Overview
                  _buildNutritionCard(recipe),
                  const SizedBox(height: 24),

                  // Food List
                  Text(
                    "Ingredients",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ...recipe.recipeEntries.map((food) => _buildFoodItem(food)),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("CONFIRM DELETE"),
                          content: const Text("Are you sure you want to delete this recipe?"),
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
                                bool isDeleted = await viewModel.deleteRecipe(recipe.id);
                                if(isDeleted){
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) => AlertDialog(
                                        title: const Text("RECIPE DELETED"),
                                        content: const Text("The recipe is deleted succesfully"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                            {
                                              Navigator.of(ctx).pop(),
                                              Navigator.of(ctx).pop(),
                                            context.push(
                                            '/search/$widget.mealLogId?mealType=${mealTypeToString(widget.mealType)}'),
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ]
                                    ),
                                  );
                                }else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to delete recipe.")),
                                  );
                                }
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'DELETE RECIPE',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              //color: colorScheme.primary,
                            ),
                            selectionColor: AccentColors.red200,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      viewModel.addTodiary(recipe);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'ADD TO DIARY',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              //color: colorScheme.primary,
                            ),
                            selectionColor: AccentColors.red200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodItem(Food food) {
    print(food.name);
    return Card(
      color: NeutralColors.light100,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(food.name, style: GoogleFonts.poppins(fontSize: 16)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${food.calories.toStringAsFixed(0)} cal", style: const TextStyle(color: NutritionColor.cabs)),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(Recipe recipe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeutralColors.light100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nutrition", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              CalorieSummary(
                calories: recipe.calories,
                carbs: recipe.carbs,
                fat: recipe.fat,
                protein: recipe.protein,
              )
            ],
          ),
        ],
      ),
    );
  }

}