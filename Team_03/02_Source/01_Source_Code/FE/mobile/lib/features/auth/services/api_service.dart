import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_info.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080/api/user-info";

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

  Future<void> userSurvey(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse(
          "https://b542ee45-7bae-4351-aae6-fd50549da5ac.mock.pstmn.io/api/users/survey"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user),
    );

    debugPrint("API Response: ${response.statusCode} - ${response.body}");

    // Check for success status codes (200-299)
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to submit survey: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8088/api/users/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsIm5hbWUiOiJKb2huIEFsZXgiLCJ1c2VySWQiOiI4YmQ5MWFhNy0wMWFhLTRmMGYtYWY1Mi04OWRiNjEzMzllYjEiLCJzdWIiOiJ0ZXN0NDRAZ21haWwuY29tIiwiaWF0IjoxNzQ0ODA4MjQ3LCJleHAiOjE3NDU0MTMwNDd9.TcoxQYr9fkjH9i0GCNzI-9S_y_SDnjvIfuCucQBqtWI",
      },
    );

    debugPrint("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch profile: ${response.body}');
    }

    try {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Extract the "data" field from the response
      if (responseBody.containsKey('data')) {
        final Map<String, dynamic> profileData = responseBody['data'];
        return profileData;
      } else {
        throw Exception("Invalid response format: 'data' field is missing");
      }
    } catch (e) {
      debugPrint("Error decoding response: $e");
      throw Exception("Failed to decode profile data");
    }
  }

  Future<Map<String, dynamic>> getGoal() async {
    final response = await http.get(
      Uri.parse(
          "https://b542ee45-7bae-4351-aae6-fd50549da5ac.mock.pstmn.io/api/users/goals"),
      headers: {"Content-Type": "application/json"},
    );

    debugPrint("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch goal: ${response.body}');
    }

    // Decode the response body
    try {
      final Map<String, dynamic> goalData = json.decode(response.body);
      return goalData;
    } catch (e) {
      debugPrint("Error decoding response: $e");
      throw Exception("Failed to decode goal data");
    }
  }
}
