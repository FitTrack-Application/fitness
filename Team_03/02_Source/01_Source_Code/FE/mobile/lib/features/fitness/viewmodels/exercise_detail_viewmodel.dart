import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/features/fitness/models/exercise.dart';
import 'package:mobile/features/fitness/services/repository/exercise_repository.dart';

// Define possible loading states
enum LoadState { initial, loading, loaded, error, timeout }

class ExerciseDetailViewModel extends ChangeNotifier {
  final ExerciseRepository _repository;
  Exercise? exercise;
  double _duration = 0;
  double get duration => _duration;

  void updateDuration(double duration) {
    if (duration > 0 && duration <= 10000) {
      _duration = duration;
      loadExercise(exercise?.id ?? '', duration: _duration);
      notifyListeners();
    }
  }

  LoadState loadState = LoadState.initial;
  String? errorMessage;

  // Timeout duration
  static const Duration _timeoutDuration = Duration(seconds: 10);

  ExerciseDetailViewModel(this._repository);

  Future<void> loadExercise(
      String exerciseId, {double duration = 0}) async {
    loadState = LoadState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository
          .getExerciseById(exerciseId)
          .timeout(_timeoutDuration, onTimeout: () {
        throw TimeoutException('Connection timed out. Please try again.');
      });

      exercise = result;

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
