import 'package:mobile/common/model/pagination.dart';
import 'package:mobile/features/fitness/models/exercise.dart';

class ExerciseRepository {
  Future<PaginatedResponse<Exercise>?> searchExercises(String query, {int page = 1, int size = 10}) async {
    // API call implementation
    return null;
  }

  Future<PaginatedResponse<Exercise>?> searchMyExercises(String query, {int page = 1, int size = 10}) async {
    // API call implementation
    return null;
  }
}