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
      Uri.parse("https://54efe02a-ae6e-4055-9391-3a9bd9cac8f1.mock.pstmn.io/api/users/survey"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user),
    );

    debugPrint("API Response: ${response.statusCode} - ${response.body}");

    // Check for success status codes (200-299)
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to submit survey: ${response.body}');
    }
  }
}
