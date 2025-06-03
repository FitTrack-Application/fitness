import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/features/fitness/services/repository/exercise_repository.dart';

// Define possible loading states
enum LoadState { initial, loading, loaded, error, timeout }

class ExerciseAddViewModel extends ChangeNotifier {
  final ExerciseRepository _repository;
  //Exercise? exercise;
  double _duration = 0;
  String _name = 'New Exercise';
  int _caloriesBurned = 0;
  double get duration => _duration;
  String get name => _name;
  int get caloriesBurned => _caloriesBurned;

  set duration(double value) {
    if (value >= 0 && value <= 10000) {
      _duration = value;
      notifyListeners();
    }
  }

  set caloriesBurned(int value) {
    if (value >= 0 && value <= 10000) {
      _caloriesBurned = value;
      notifyListeners();
    }
  }

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
      notifyListeners();
    }
  }

  LoadState loadState = LoadState.loaded;
  String? errorMessage;

  // Timeout duration
  static const Duration _timeoutDuration = Duration(seconds: 10);

  ExerciseAddViewModel(this._repository);

  Future<void> createMyExercise() async {
    loadState = LoadState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository
          .createMyExercise(name, duration, caloriesBurned)
          .timeout(_timeoutDuration, onTimeout: () {
        throw TimeoutException('Connection timed out. Please try again.');
      });

      //exercise = result;

      loadState = LoadState.loaded;
    } on TimeoutException catch (e) {
      loadState = LoadState.timeout;
      errorMessage = e.message;
    } catch (e) {
      loadState = LoadState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
