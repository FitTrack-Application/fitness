import 'package:dio/dio.dart';
import 'package:mobile/common/model/pagination.dart';
import 'package:mobile/cores/utils/dio/dio_client.dart';
import 'package:mobile/features/fitness/models/exercise.dart';

class ExerciseRepository {

  final Dio _dio = DioClient().dio;

  Future<PaginatedResponse<Exercise>?> searchExercises(String name, {int page = 1, int size = 10}) async {
    // API call implementation
    try {
      print('📤 Requesting searchExercises with name="$name", page=$page, size=$size');

      final response = await _dio.get(
        '/api/exercises',
        queryParameters: {
          'query': name,
          'page': page,
          'size': size,
        },
      );

      final data = response.data;
      print('✅ Response received for searchExercises');
      print('📦 Total items fetched: ${data['data']?.length ?? 0}');

      final List<dynamic> exerciseListJson = data['data'] ?? [];
      final Map<String, dynamic> paginationJson =
          data['metadata']?['pagination'] ?? {};

      final exercises = exerciseListJson.map((item) => Exercise.fromJson(item)).toList();

      return PaginatedResponse<Exercise>(
        message: data['generalMessage'] ?? 'Success',
        data: exercises,
        pagination: Pagination(
          currentPage: paginationJson['currentPage'] ?? 1,
          pageSize: paginationJson['pageSize'] ?? size,
          totalItems: paginationJson['totalItems'] ?? exercises.length,
          totalPages: paginationJson['totalPages'] ?? 1,
        ),
      );
    } catch (e, stack) {
      print('🔥 Exception during searchExercises: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<PaginatedResponse<Exercise>?> searchMyExercises(String name, {int page = 1, int size = 10}) async {
    // API call implementation
    try {
      print('📤 Requesting searchMyExercises with name="$name", page=$page, size=$size');

      final response = await _dio.get(
        '/api/exercises/me',
        queryParameters: {
          'query': name,
          'page': page,
          'size': size,
        },
      );

      final data = response.data;
      print('✅ Response received for searchMyExercises');
      print('📦 Total items fetched: ${data['data']?.length ?? 0}');

      final List<dynamic> exerciseListJson = data['data'] ?? [];
      final Map<String, dynamic> paginationJson =
          data['metadata']?['pagination'] ?? {};

      final exercises = exerciseListJson.map((item) => Exercise.fromJson(item)).toList();

      return PaginatedResponse<Exercise>(
        message: data['generalMessage'] ?? 'Success',
        data: exercises,
        pagination: Pagination(
          currentPage: paginationJson['currentPage'] ?? 1,
          pageSize: paginationJson['pageSize'] ?? size,
          totalItems: paginationJson['totalItems'] ?? exercises.length,
          totalPages: paginationJson['totalPages'] ?? 1,
        ),
      );
    } catch (e, stack) {
      print('🔥 Exception during searchExercises: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<Exercise> getExerciseById( String exerciseId ) async {
    try {
      print('📤 Requesting getExerciseById with exerciseId: $exerciseId');

      final response = await _dio.get(
        '/api/exercises/$exerciseId',
      );

      final data = response.data['data'];
      print('✅ Response received for getExerciseById');

      return Exercise.fromJson(data);
    } catch (e, stack) {
      print('🔥 Exception during getExerciseById: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<Exercise> createMyExercise( String name, double duration, int caloriesBurned) async {
    try {
      print('📤 Requesting createMyExercise with name: $name');

      final response = await _dio.post(
        '/api/exercises',
        data: {
          'name': name,
          'duration': duration,
          'caloriesBurned': caloriesBurned,
        },
      );

      final data = response.data['data'];
      print('✅ Response received for createMyExercise');

      return Exercise.fromJson(data);
    } catch (e, stack) {
      print('🔥 Exception during getExerciseById: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }
}