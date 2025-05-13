import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/features/auth/models/user_info.dart';
import '../../../../cores/utils/dio/dio_client.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080/api/user-info";
  final Dio _dio = DioClient().dio;
  Future<List<UserInfo>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserInfo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> createUser(UserInfo user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

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
      final response = await _dio.put(
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

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get("/api/fit-profiles/me");

      debugPrint("API Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Failed to fetch profile: ${response.data}');
      }

      // Extract the "data" field from the response
      if (response.data.containsKey('data')) {
        return response.data['data'];
      } else {
        throw Exception("Invalid response format: 'data' field is missing");
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      throw Exception("Failed to fetch profile");
    }
  }

  Future<Map<String, dynamic>> getGoal() async {
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
      throw Exception("Failed to fetch goal");
    }
  }
}
