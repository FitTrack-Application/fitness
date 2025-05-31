import 'package:dio/dio.dart';
import '../../../../cores/utils/dio/dio_client.dart';
import '../../models/exercise_entry.dart';
import '../../models/workout_log.dart';
import '../../models/exercise.dart';

class WorkoutLogRepository {
  final Dio _dio = DioClient().dio;

  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// 1. Fetch WorkoutLog theo ngày
  Future<WorkoutLogFitness?> fetchWorkoutLogForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    print('📅 Fetching workout log for date: $formattedDate');

    try {
      final response = await _dio.get(
        '/api/exercise-logs',
        queryParameters: {'date': formattedDate},
      );

      final data = response.data['data'];
      if (data == null) {
        print('📭 No workout log found for date: $formattedDate');
        return null;
      }

      print('📦 Received workout log for $formattedDate');

      final entriesJson = data['exerciseLogEntries'] as List<dynamic>;
      print('🏋️ Contains ${entriesJson.length} exercise entries');

      final entries = entriesJson.map((entryJson) {
        return ExerciseEntry.fromJson(entryJson);
      }).toList();

      return WorkoutLogFitness(
        id: data['id'],
        date: DateTime.parse(data['date']),
        exerciseEntries: entries,
      );
    } on DioException catch (e) {
      print('🔥 Error fetchWorkoutLogForDate: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 2. Tạo workout log cho ngày cụ thể
  Future<WorkoutLogFitness?> createWorkoutLogForDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    print('🆕 Creating workout log for date: $formattedDate');

    try {
      final response = await _dio.post(
        '/api/exercise-logs',
        data: {'date': formattedDate},
      );

      if (response.data['status'] != 201) {
        print('❗️ Failed to create workout log: ${response.data['status']} ${response.data['generalMessage']}');
        return null;
      }

      print('✅ Workout log created for $formattedDate');

      return fetchWorkoutLogForDate(date);
    } on DioException catch (e) {
      print('🔥 Error createWorkoutLogForDate: ${e.response?.statusCode} ${e.message}');
      if (e.response?.statusCode == 404) {
        return null;
      } else if (e.response?.statusCode == 400) {
        print('Error: Workout log have not created on this day - Try to create workout log on this day');
        return createWorkoutLogForDate(date);
      }
      rethrow;
    }
  }

  /// 3. Thêm exercise entry vào workout log
  Future<ExerciseEntry> addExerciseEntry({
    required String workoutLogId,
    required String exerciseId,
    required double duration,
  }) async {
    final path = '/api/exercise-logs/$workoutLogId/entries';
    final body = {
      'exerciseId': exerciseId,
      'duration': duration,
    };

    print('➕ Adding exercise entry to log $workoutLogId: $body');

    try {
      final response = await _dio.post(path, data: body);
      final data = response.data['data'];
      print('✅ Exercise entry added: ${data['id']}');

      return ExerciseEntry.fromJson(data);
    } on DioException catch (e) {
      print('🔥 Error addExerciseEntry: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 4. Chỉnh sửa exercise entry
  Future<ExerciseEntry> editExerciseEntry({
    required String exerciseEntryId,
    required String exerciseId,
    required int duration,
  }) async {
    final path = '/api/exercise-log-entries/$exerciseEntryId';
    final body = {
      'exerciseId': exerciseId,
      'duration': duration,
    };

    print('✏️ Editing exercise entry $exerciseEntryId: $body');

    try {
      final response = await _dio.put(path, data: body);
      final data = response.data['data'];
      print('✅ Edited exercise entry: ${data['id']}');

      return ExerciseEntry.fromJson(data);
    } on DioException catch (e) {
      print('🔥 Error editExerciseEntry: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 5. Xóa exercise entry
  Future<void> deleteExerciseEntry(String exerciseEntryId) async {
    final path = '/api/exercise-log-entries/$exerciseEntryId';
    print('❌ Deleting exercise entry: $exerciseEntryId');

    try {
      await _dio.delete(path);
      print('✅ Deleted exercise entry: $exerciseEntryId');
    } on DioException catch (e) {
      print('🔥 Error deleteExerciseEntry: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }

  /// 6. Lấy calories goal cho exercise
  Future<int> fetchExerciseCaloriesGoal() async {
    print('🎯 Fetching user exercise calories goal...');

    try {
      final response = await _dio.get('/api/fitness-goals/me');
      final caloriesBurnGoal = response.data['data']['caloriesBurnGoal'] as int;
      print('✅ Exercise calories burn goal: $caloriesBurnGoal');
      return caloriesBurnGoal;
    } on DioException catch (e) {
      print('🔥 Error fetchExerciseCaloriesGoal: ${e.response?.statusCode} ${e.message}');
      rethrow;
    }
  }
}
