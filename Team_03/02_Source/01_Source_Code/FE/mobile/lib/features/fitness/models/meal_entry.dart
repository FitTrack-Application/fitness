import 'package:mobile/features/fitness/models/food.dart';
import 'package:mobile/features/fitness/models/serving_unit.dart';

class MealEntry {
  final String id;
  final Food food;
  final ServingUnit servingUnit;
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
      food: Food.fromJson(json['foodId']),
      servingUnit: json['servingUnit'] != null
          ? ServingUnit.fromJson(json['servingUnit'])
          : ServingUnit(id: '', unitName: 'Gram', unitSymbol: 'g'),
      numberOfServings: (json['numberOfServings'] ?? 1).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }

  factory MealEntry.fromJsonWithFood(Map<String, dynamic> json, Food food) {
    return MealEntry(
      id: json['id'],
      food: food,
      servingUnit: json['servingUnit'] != null
          ? ServingUnit.fromJson(json['servingUnit'])
          : ServingUnit(id: '', unitName: 'Gram', unitSymbol: 'g'),
      numberOfServings: (json['numberOfServings'] ?? 1).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'servingUnit': servingUnit.toJson(),
      'numberOfServings': numberOfServings,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}