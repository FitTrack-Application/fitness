import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/features/fitness/view/food_detail/widget/calorie_summary.dart';

import '../../../../cores/constants/colors.dart';
import '../../models/food.dart';
import '../../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
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
                  "Description",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

            if (recipe.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  recipe.description,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),

            // Nutrition Overview
            _buildNutritionCard(),

            const SizedBox(height: 24),

            // Food List
            Text(
              "Ingredients",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            ...recipe.foodList.map((food) => _buildFoodItem(food)),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Food food) {
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

  Widget _buildNutritionCard() {
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
          Text("Nutrition (per ${recipe.servingSize.toStringAsFixed(0)} ${recipe.unit})", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
