import 'package:mobile/features/fitness/models/exercise.dart';

class ExerciseEntry {
  final String id;
  final Exercise exercise;
  final int duration; // in minutes
  final int caloriesBurned;

  ExerciseEntry({
    required this.id,
    required this.exercise,
    required this.duration,
    required this.caloriesBurned,
  });

  factory ExerciseEntry.fromJson(Map<String, dynamic> json) {
    return ExerciseEntry(
      id: json['id'],
      exercise: Exercise.fromJson(json['exercise']),
      duration: json['duration'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise.toJson(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
    };
  }
}