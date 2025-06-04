import 'package:meta/meta.dart';
import 'dart:convert';

AiFood aiFoodFromJson(String str) => AiFood.fromJson(json.decode(str));

String aiFoodToJson(AiFood data) => json.encode(data.toJson());

class AiFood {
  final String foodId;
  final String servingUnitId;
  final double numberOfServings;

  AiFood({
    required this.foodId,
    required this.servingUnitId,
    required this.numberOfServings,
  });

  AiFood copyWith({
    String? foodId,
    String? servingUnitId,
    double? numberOfServings,
  }) =>
      AiFood(
        foodId: foodId ?? this.foodId,
        servingUnitId: servingUnitId ?? this.servingUnitId,
        numberOfServings: numberOfServings ?? this.numberOfServings,
      );

  factory AiFood.fromJson(Map<String, dynamic> json) => AiFood(
    foodId: json["food_id"],
    servingUnitId: json["serving_unit_id"],
    numberOfServings: json["number_of_servings"],
  );

  Map<String, dynamic> toJson() => {
    "food_id": foodId,
    "serving_unit_id": servingUnitId,
    "number_of_servings": numberOfServings,
  };
}
