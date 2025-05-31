import 'package:mobile/features/fitness/models/serving_unit.dart';
import 'food.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final ServingUnit servingUnit;
  final double numberOfServings;
  final List<Food> foodList;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.servingUnit,
    required this.numberOfServings,
    required this.foodList,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      numberOfServings: (json['numberOfServings'] as num?)?.toDouble() ?? 1.0,
      servingUnit: json['servingUnit'] != null
          ? ServingUnit.fromJson(json['servingUnit'])
          : ServingUnit(
        id: '',
        unitName: 'Gram',
        unitSymbol: 'g',
      ),
      foodList: (json['foodList'] as List<dynamic>? ?? [])
          .map((item) => Food.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'servingUnit': servingUnit.toJson(),
      'numberOfServings': numberOfServings,
      'foodList': foodList.map((food) => food.toJson()).toList(),
    };
  }

  // Total nutritional values (computed from foodList)
  double get calories =>
      foodList.fold(0, (sum, food) => sum + food.calories);

  double get protein =>
      foodList.fold(0, (sum, food) => sum + food.protein);

  double get fat =>
      foodList.fold(0, (sum, food) => sum + food.fat);

  double get carbs =>
      foodList.fold(0, (sum, food) => sum + food.carbs);

// For the display unit
  String get unit => servingUnit.unitName;

}
