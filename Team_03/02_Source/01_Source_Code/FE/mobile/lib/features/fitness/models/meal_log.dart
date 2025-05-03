import 'meal_entry.dart';

enum MealType { breakfast, lunch, dinner, snack }

MealType mealTypeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'BREAKFAST':
      return MealType.breakfast;
    case 'LUNCH':
      return MealType.lunch;
    case 'DINNER':
      return MealType.dinner;
    case 'SNACK':
      return MealType.snack;
    default:
      throw Exception("Unknown MealType: $value");
  }
}

String mealTypeToString(MealType mealType) {
  switch (mealType) {
    case MealType.breakfast:
      return 'Breakfast';
    case MealType.lunch:
      return 'Lunch';
    case MealType.dinner:
      return 'Dinner';
    case MealType.snack:
      return 'Snack';
  }
}

class MealLogFitness {
  final String id;
  final DateTime date;
  final MealType mealType;
  final List<MealEntry> mealEntries;

  MealLogFitness({
    required this.id,
    required this.date,
    required this.mealType,
    required this.mealEntries,
  });

  factory MealLogFitness.fromJson(Map<String, dynamic> json) {
    return MealLogFitness(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: mealTypeFromString(json['mealType']),
      mealEntries: (json['mealEntries'] as List<dynamic>)
          .map((e) => MealEntry.fromJson(e))
          .toList(),
    );
  }
}
