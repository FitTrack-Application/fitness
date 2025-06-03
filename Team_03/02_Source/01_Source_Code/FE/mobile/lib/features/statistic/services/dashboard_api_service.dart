import '../../fitness/services/api_client.dart';
import '../models/dashboard.dart';
import '../models/weight_entry.dart';
import '../models/step_entry.dart';
import 'package:dio/dio.dart';
import '../../../../cores/utils/dio/dio_client.dart';
import 'package:flutter/material.dart';

class DashboardApiService {
  final ApiClient apiClient;
  final Dio _dio = DioClient().dio;

  DashboardApiService(this.apiClient);

  Future<DashboardLogModel> fetchDashboardData() async {
    try {
      print('📤 Requesting getDashboardInfo');

      final response = await _dio.get("/api/dashboard/me");

      print('📥 Raw data type: ${response.data['data'].runtimeType}');
      print('📥 Raw data: ${response.data['data']}');

      final data = response.data['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception("Unexpected format: 'data' is not a map.");
      }

      return DashboardLogModel.fromJson(data);
    } catch (e, stack) {
      print('🔥 Error in fetchDashboardData: $e');
      print('📉 Stacktrace:\n$stack');
      rethrow;
    }
  }

  Future<List<WeightEntry>> fetchWeightStatistics(BuildContext context) async {
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
      String errorMessage = "An error occurred";
      if (e.response?.statusCode != null) {
        final statusCode = e.response?.statusCode;
        final serverMessage = e.response?.data.toString();
        errorMessage =
            "Error fetching weight statistics: Status code $statusCode - $serverMessage";
      }

      // Show error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      print('DioException: ${e.message}');
      return [
        WeightEntry(date: DateTime.now(), weight: 0), // Default entry
      ];
    } catch (e) {
      print('Error fetching weight statistics: $e');

      // Show generic error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching weight statistics"),
          backgroundColor: Colors.red,
        ),
      );

      // Return a default list in case of any other error
      return [
        WeightEntry(date: DateTime.now(), weight: 0),
      ];
    }
  }

  Future<List<StepEntry>> fetchStepStatistics(BuildContext context) async {
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
          StepEntry(
              date: DateTime.now().subtract(const Duration(days: 1)), steps: 0),
        ];
      }

      // Parse the response into a list of StepEntry objects
      return data.map((entry) => StepEntry.fromJson(entry)).toList();
    } on DioException catch (e) {
      String errorMessage = "An error occurred";
      if (e.response?.statusCode != null) {
        final statusCode = e.response?.statusCode;
        final serverMessage = e.response?.data.toString();
        errorMessage =
            "Error fetching step statistics: Status code $statusCode";
      }

      // Show error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      print('DioException: ${e.message}');
      return [
        StepEntry(date: DateTime.now(), steps: 0), // Default entry
        StepEntry(date: DateTime.now().subtract(Duration(days: 1)), steps: 0),
      ];
    } catch (e) {
      print('Error fetching step statistics: $e');

      // Show generic error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching step statistics"),
          backgroundColor: Colors.red,
        ),
      );

      // Return a default list in case of any other error
      return [
        StepEntry(date: DateTime.now(), steps: 0),
        StepEntry(
            date: DateTime.now().subtract(const Duration(days: 1)), steps: 0),
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
