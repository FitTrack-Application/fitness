class Food {
  final String id;
  final String name;
  final double servingSize;
  final int calories;
  final int carbs;
  final int fat;
  final int protein;
  final String unit;
  final String description;
  final MealType mealType;

  Food({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.unit,
    required this.description,
    this.mealType = MealType.breakfast,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['foodId'] ?? '',
      name: json['foodName'] ?? '',
      calories: (json['calories'] ?? 0).toInt(),
      protein: (json['protein'] ?? 0).toInt(),
      carbs: (json['carbs'] ?? 0).toInt(),
      fat: (json['fat'] ?? 0).toInt(),
      servingSize: (json['servingSize'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'grams',
      description: json['description'] ?? '',
    );
  }
}

// Thêm enum MealType nếu chưa có
enum MealType {
  breakfast,
  lunch,
  dinner
}
