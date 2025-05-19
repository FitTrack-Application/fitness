import 'food.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final double servingSize;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final String unit;
  final List<Food> foodList;
  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.servingSize,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.unit,
    required this.foodList
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      servingSize: 100.0, // Mặc định
      unit: 'grams', // Mặc định
      foodList: (json['foodList'] as List<dynamic>? ?? [])
          .map((item) => Food.fromJson(item))
          .toList(),
    );
  }
}