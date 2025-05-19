import 'package:mobile/features/fitness/models/serving_unit.dart';

class Food {
  final String id;
  final String name;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final String imageUrl;
  final ServingUnit servingUnit;
  final double numberOfServings;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.imageUrl,
    required this.servingUnit,
    required this.numberOfServings,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      numberOfServings: (json['numberOfServings'] ?? 1).toDouble(),
      servingUnit: json['servingUnit'] != null
          ? ServingUnit.fromJson(json['servingUnit'])
          : ServingUnit(
        id: '',
        unitName: 'Gram',
        unitSymbol: 'g',
      ),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
      'imageUrl': imageUrl,
      'servingUnit': servingUnit.toJson(),
      'numberOfServings': numberOfServings,
    };
  }
}