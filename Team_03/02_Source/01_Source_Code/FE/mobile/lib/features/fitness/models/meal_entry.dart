import 'package:mobile/features/fitness/models/food.dart';

class MealEntry {
  final String id;
  final Food food;
  final String servingUnit;
  final double numberOfServings;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MealEntry({
    required this.id,
    required this.food,
    required this.servingUnit,
    required this.numberOfServings,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      food: json['foodId'],
      servingUnit: json['servingUnit'],
      numberOfServings: (json['numberOfServings'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }
}