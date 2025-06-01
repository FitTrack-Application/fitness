import 'exercise_entry.dart';

class WorkoutLogFitness {
  final String id;
  final DateTime date;
  final List<ExerciseEntry> exerciseEntries;

  WorkoutLogFitness({
    required this.id,
    required this.date,
    required this.exerciseEntries,
  });

  int get totalCaloriesBurned {
    return exerciseEntries.fold(0, (sum, entry) => sum + entry.caloriesBurned);
  }

  int get totalDuration {
    return exerciseEntries.fold(0, (sum, entry) => sum + entry.duration);
  }

  factory WorkoutLogFitness.fromJson(Map<String, dynamic> json) {
    return WorkoutLogFitness(
      id: json['id'],
      date: DateTime.parse(json['date']),
      exerciseEntries: (json['exerciseLogEntries'] as List<dynamic>)
          .map((e) => ExerciseEntry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'exerciseLogEntries': exerciseEntries.map((e) => e.toJson()).toList(),
    };
  }
}