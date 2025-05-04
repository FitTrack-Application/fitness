class Food {
  final String id;
  final String name;
  final double calories;
  final double carbs;
  final double fat;
  final double protein;
  final String imageUrl;
  final String servingUnit;
  final double numberOfServings;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
    required this.imageUrl,
    this.servingUnit = 'Gram',
    this.numberOfServings = 1.0,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      servingUnit: json['servingUnit'] ?? 'Gram',
      numberOfServings: (json['numberOfServings'] ?? 1).toDouble(),
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
      'servingUnit': servingUnit,
      'numberOfServings': numberOfServings,
    };
  }
}
