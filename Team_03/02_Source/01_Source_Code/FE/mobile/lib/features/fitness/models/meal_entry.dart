class MealEntry {
  final String id;
  final String foodId;
  final String servingUnit;
  final double numberOfServings;

  MealEntry({
    required this.id,
    required this.foodId,
    required this.servingUnit,
    required this.numberOfServings,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      foodId: json['foodId'],
      servingUnit: json['servingUnit'],
      numberOfServings: (json['numberOfServings'] as num).toDouble(),
    );
  }
}