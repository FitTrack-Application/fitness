import 'meal_log.dart';

class Food {
  final String id;
  final String name;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final MealType mealType;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    this.mealType = MealType.breakfast,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
    );
  }
}