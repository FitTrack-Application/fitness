class Food {
  final String id;
  final String name;
  final double servingSize;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
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
    this.mealType = MealType.Breakfast,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      servingSize: 100.0, // Mặc định
      unit: 'grams', // Mặc định
      description: '', // Mặc định
    );
  }
}

enum MealType {
  breakfast,
  lunch,
  dinner,
}