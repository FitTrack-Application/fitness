import 'package:mobile/features/fitness/models/food.dart';

class MealEntry {
  final String id;
  final Food food;
  final String servingUnit;
  final double numberOfServings;

  MealEntry({
    required this.id,
    required this.food,
    required this.servingUnit,
    required this.numberOfServings,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      food: json['foodId'],
      servingUnit: json['servingUnit'],
      numberOfServings: (json['numberOfServings'] as num).toDouble(),
    );
  }
}