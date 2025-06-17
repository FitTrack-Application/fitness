import 'food.dart';

class Recipe {
  final String id;
  final String name;
  final String direction;
  final List<Food> recipeEntries;

  Recipe({
    required this.id,
    required this.name,
    required this.direction,
    required this.recipeEntries,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      direction: json['direction'] ?? '',
      recipeEntries: (json['recipeEntries'] as List<dynamic>? ?? [])
          .map((item) => Food.recipeEntriesFromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'direction': direction,
      //'servingUnit': servingUnit.toJson(),
      //'numberOfServings': numberOfServings,
      'recipeEntries': recipeEntries.map((food) => food.idToJson()).toList(),
    };
  }

  // Total nutritional values (computed from foodList)
  double get numberOfServings =>
      recipeEntries.fold(0, (sum, food) => sum + food.numberOfServings);
  double get calories =>
      recipeEntries.fold(0, (sum, food) => sum + food.calories);

  double get protein =>
      recipeEntries.fold(0, (sum, food) => sum + food.protein);

  double get fat =>
      recipeEntries.fold(0, (sum, food) => sum + food.fat);

  double get carbs =>
      recipeEntries.fold(0, (sum, food) => sum + food.carbs);
}
