import '../../fitness/services/api_client.dart';
import '../models/dashboard.dart';
import '../models/weight_entry.dart';
import '../models/step_entry.dart';
import 'package:dio/dio.dart';
import '../../../../cores/utils/dio/dio_client.dart';

class DashboardApiService {
  final ApiClient apiClient;
  final Dio _dio = DioClient().dio;

  DashboardApiService(this.apiClient);

  Future<DashboardLogModel> fetchDashboardData(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await apiClient.get('api/dashboard',
        queryParams: null, headers: headers);

    return DashboardLogModel.fromJson(response);
  }

  Future<List<WeightEntry>> fetchWeightStatistics() async {
    try {
      // Make the API request to the new endpoint
      final response = await _dio.get(
        "/api/weight-logs/me",
        queryParameters: {"days": 7},
      );

      // Log the response for debugging
      print('API Response: ${response.data}');

      // Check if the data field is empty
      final List<dynamic> data = response.data['data'];
      if (data.isEmpty) {
        print('No weight logs found! Returning default list.');
        return [WeightEntry(date: DateTime.now(), weight: 0)]; // Default entry
      }

      // Parse the response into a list of WeightEntry objects
      return data.map((entry) => WeightEntry.fromJson(entry)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error: Resource not found (404). Returning default list.');
        return [
          WeightEntry(date: DateTime.now(), weight: 0) // Default entry
        ];
      } else {
        print('DioException: ${e.message}');
        rethrow; // Re-throw for other status codes
      }
    } catch (e) {
      print('Error fetching weight statistics: $e');
      // Return a default list in case of any other error
      return [
        WeightEntry(date: DateTime.now(), weight: 0),
      ];
    }
  }

  Future<List<StepEntry>> fetchStepStatistics() async {
    try {
      // Make the API request to the new endpoint
      final response = await _dio.get(
        "/api/step-logs/me",
        queryParameters: {"days": 7},
      );

      // Log the response for debugging
      print('API Response: ${response.data}');

      // Check if the data field is empty
      final List<dynamic> data = response.data['data'];
      if (data.isEmpty) {
        print('No step logs found! Returning default list.');
        return [
          StepEntry(date: DateTime.now(), steps: 0), // Default entry
          StepEntry(date: DateTime.now().subtract(Duration(days: 1)), steps: 0),
        ];
      }

      // Parse the response into a list of StepEntry objects
      return data.map((entry) => StepEntry.fromJson(entry)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error: Resource not found (404). Returning default list.');
        return [
          StepEntry(date: DateTime.now(), steps: 100), // Default entry
          StepEntry(
              date: DateTime.now().subtract(Duration(days: 1)), steps: 500),
        ];
      } else {
        print('DioException: ${e.message}');
        rethrow; // Re-throw for other status codes
      }
    } catch (e) {
      print('Error fetching step statistics: $e');
      // Return a default list in case of any other error
      return [
        StepEntry(date: DateTime.now(), steps: 0),
        StepEntry(date: DateTime.now().subtract(Duration(days: 1)), steps: 0),
      ];
    }
  }

  // Add a new weight log
  Future<void> addWeightLog({
    required double weight,
    required String date,
    String? progressPhoto,
  }) async {
    try {
      final body = {
        "weight": weight.toString(),
        "updateDate": date,
        "progressPhoto": progressPhoto,
      };

      final response = await _dio.post(
        "/api/weight-logs/me",
        data: body,
      );

      print('Weight log added successfully: ${response.data}');
    } catch (e) {
      print('Error adding weight log: $e');
      rethrow;
    }
  }

  // Add a new step log
  Future<void> addStepLog({
    required int steps,
    required String date,
  }) async {
    try {
      final body = {
        "steps":
            steps.toString(), // Convert steps to String as required by the API
        "date": date,
      };

      print('Request Payload: $body'); // Log the payload

      final response = await _dio.post(
        "/api/step-logs/me",
        data: body,
      );

      print('Step log added successfully: ${response.data}');
    } catch (e) {
      print('Error adding step log: $e');
      rethrow;
    }
  }
}
