import '../../fitness/services/api_client.dart';
import '../models/dashboard.dart';
import '../models/weight_entry.dart';
import '../models/step_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class DashboardApiService {
  final ApiClient apiClient;
  final Dio dio;
  final FlutterSecureStorage _storage;

  DashboardApiService(this.apiClient, this.dio, this._storage);

  Future<DashboardLogModel> fetchDashboardData(String token) async {
    final headers = {'Authorization': 'Bearer $token'};
    final response = await apiClient.get('api/dashboard',
        queryParams: null, headers: headers);

    return DashboardLogModel.fromJson(response);
  }

  Future<List<WeightEntry>> fetchWeightStatistics() async {
    try {
      // Retrieve the access token from FlutterSecureStorage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      // Add the Authorization header
      final headers = {'Authorization': 'Bearer $accessToken'};

      // Make the API request to the new endpoint
      final response = await dio.get(
        "http://10.0.2.2:8088/api/weight-logs/me?days=7",
        options: Options(headers: headers),
      );

      // Log the response for debugging
      print('API Response: ${response.data}');

      // Check if the data field is empty
      final List<dynamic> data = response.data['data'];
      if (data.isEmpty) {
        print('No weight logs found! Returning default list.');
        return [
          WeightEntry(date: DateTime.now(), weight: 0), // Default entry
          WeightEntry(
              date: DateTime.now().subtract(Duration(days: 1)), weight: 0),
        ];
      }

      // Parse the response into a list of WeightEntry objects
      return data.map((entry) => WeightEntry.fromJson(entry)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error: Resource not found (404). Returning default list.');
        return [
          WeightEntry(date: DateTime.now(), weight: 100), // Default entry
          WeightEntry(
              date: DateTime.now().subtract(Duration(days: 1)), weight: 500),
        ];
      } else {
        print('DioException: ${e.message}');
        rethrow; // Re-throw for other status codes
      }
    } catch (e) {
      print('Error fetching step statistics: $e');
      // Return a default list in case of any other error
      return [
        WeightEntry(date: DateTime.now(), weight: 0),
        WeightEntry(
            date: DateTime.now().subtract(Duration(days: 1)), weight: 0),
      ];
    }
  }

  Future<List<StepEntry>> fetchStepStatistics() async {
    try {
      // Retrieve the access token from FlutterSecureStorage
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      // Add the Authorization header
      final headers = {'Authorization': 'Bearer $accessToken'};

      // Make the API request to the new endpoint
      final response = await dio.get(
        "http://10.0.2.2:8088/api/step-logs/me?days=7",
        options: Options(headers: headers),
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
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      final headers = {'Authorization': 'Bearer $accessToken'};
      final body = {
        "weight": weight.toString(),
        "date": date,
        "progressPhoto": progressPhoto,
      };

      final response = await dio.post(
        "http://10.0.2.2:8088/api/weight-logs/me",
        data: body,
        options: Options(headers: headers),
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
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        throw Exception('Access token is missing. Please log in again.');
      }

      final headers = {'Authorization': 'Bearer $accessToken'};
      final body = {
        "steps": steps.toString(),
        "date": date,
      };

      final response = await dio.post(
        "http://10.0.2.2:8088/api/step-logs/me",
        data: body,
        options: Options(headers: headers),
      );

      print('Step log added successfully: ${response.data}');
    } catch (e) {
      print('Error adding step log: $e');
      rethrow;
    }
  }
}
