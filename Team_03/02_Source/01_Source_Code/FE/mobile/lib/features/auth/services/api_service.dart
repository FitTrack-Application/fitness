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
      Uri.parse("https://b542ee45-7bae-4351-aae6-fd50549da5ac.mock.pstmn.io/api/users/survey"),
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
    Uri.parse("https://b542ee45-7bae-4351-aae6-fd50549da5ac.mock.pstmn.io/api/users/me"),
    headers: {"Content-Type": "application/json"},
  );

  debugPrint("API Response: ${response.statusCode} - ${response.body}");

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to fetch goal: ${response.body}');
  }

  // Decode the response body
  try {
    final Map<String, dynamic> profileData = json.decode(response.body);
    return profileData;
  } catch (e) {
    debugPrint("Error decoding response: $e");
    throw Exception("Failed to decode goal data");
  }
}

  Future<Map<String, dynamic>> getGoal() async {
    final response = await http.get(
      Uri.parse("https://b542ee45-7bae-4351-aae6-fd50549da5ac.mock.pstmn.io/api/users/goals"),
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
