import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../cores/utils/dio/dio_client.dart';

class ApiService {
  // static const String baseUrl = "http://localhost:8080/api/user-info";
  final Dio _dio = DioClient().dio;
  // Future<List<UserInfo>> fetchUsers() async {
  //   final response = await http.get(Uri.parse(baseUrl));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => UserInfo.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  // Future<void> createUser(UserInfo user) async {
  //   final response = await http.post(
  //     Uri.parse(baseUrl),
  //     headers: {"Content-Type": "application/json"},
  //     body: json.encode(user.toJson()),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to create user');
  //   }
  // }

  Future<bool> checkSurvey() async {
    try {
      final response = await _dio.get("/api/surveys/me");

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to check survey: ${response.data}');
      }

      if (response.data.containsKey('data') &&
          response.data['data']['hasSurvey'] != null) {
        return response.data['data']['hasSurvey'];
      } else {
        throw Exception(
            "Invalid response format: 'hasSurvey' field is missing");
      }
    } catch (e) {
      debugPrint("Error checking survey: $e");
      throw Exception("Failed to check survey");
    }
  }

  Future<void> userSurvey(Map<String, dynamic> user) async {
    try {
      final response = await _dio.post(
        "/api/surveys/me",
        data: user,
      );

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      // Check for success status codes (200-299)
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to submit survey: ${response.data}');
      }
    } catch (e) {
      debugPrint("Error submitting survey: $e");
      throw Exception("Failed to submit survey");
    }
  }

  Future<Map<String, dynamic>> getProfile(BuildContext context) async {
    try {
      final response = await _dio.get("/api/fit-profiles/me");

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to fetch profile(api): ${response.data}');
      }

      // Extract the "data" field from the response
      if (response.data.containsKey('data')) {
        return response.data['data'];
      } else {
        throw Exception("Invalid response format: 'data' field is missing");
      }
    } catch (e) {
      debugPrint("Error editing profile: $e");

      // Extract status code and error message from DioException
      String errorMessage = "An error occurred";
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final serverMessage = e.response?.data.toString();
        errorMessage = "Error editing profile: Status code $statusCode";
      }

      // Show error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
    throw Exception("Failed to fetch profile due to an unknown error");
  }

  Future<void> editProfile(Map<String, dynamic> profileData,
      {File? imageFile, required BuildContext context}) async {
    try {
      // Create a FormData object
      final formData = FormData.fromMap({
        'data': jsonEncode(profileData), // Profile data as a JSON string

        if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last, // Extract filename
            contentType: MediaType('image', 'png'),
          ),
      });
      // Send the request
      final response = await _dio.post(
        "/api/fit-profiles/me",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      debugPrint("Error editing profile: $e");

      // Extract status code and error message from DioException
      String errorMessage = "An error occurred";
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final serverMessage = e.response?.data.toString();
        errorMessage = "Error editing profile: Status code $statusCode";
      }

      // Show error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getGoal(BuildContext context) async {
    try {
      final response = await _dio.get("/api/weight-goals/me");

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to fetch goal: ${response.data}');
      }

      // Decode the response body
      return response.data;
    } catch (e) {
      debugPrint("Error fetching goal: $e");

      // Extract status code and error message from DioException
      String errorMessage = "An error occurred";
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final serverMessage = e.response?.data.toString();
        errorMessage =
            "Error fetching goal: Status code $statusCode - $serverMessage";
      }

      // Show error message as a pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      throw Exception(
          errorMessage); // Re-throw the exception for further handling
    }
  }

  Future<void> editGoal(Map<String, dynamic> goalData, context) async {
    try {
      final response = await _dio.put(
        "/api/weight-goals/me", // Assuming the endpoint for editing goals
        data: goalData,
      );

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to edit goal: ${response.data}');
      }
    } catch (e) {
      debugPrint("Error editing goal: $e");
      throw Exception("Failed to edit goal");
    }
  }
}
