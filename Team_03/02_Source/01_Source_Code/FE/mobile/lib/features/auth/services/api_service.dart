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
      Uri.parse("http://localhost:8088/api/fit-profiles/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJtdWVVN1BCcEtENFA5LXhpNjQtSUZMNUtXaDhrTV93M19JS1lDck02bW5ZIn0.eyJleHAiOjE3NDYyODc0NDEsImlhdCI6MTc0NjI4Mzg0MSwiYXV0aF90aW1lIjoxNzQ2MjgzODQwLCJqdGkiOiJvbnJ0YWM6NmRjNGNmOWEtNWUwMi00MDIxLWEwZDktNTM2NTZiZWIzZGVkIiwiaXNzIjoiaHR0cDovLzEwLjAuMi4yOjg4ODgvcmVhbG1zL215LWZpdG5lc3MiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiNDJjMTljZjQtNjFmYS00YzFkLWI4YjItYmQ4NmI5MGU5MTI3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiZmx1dHRlci1hcHAtY2xpZW50Iiwic2lkIjoiZWM4OTYzNDctZmE3Yi00OGNjLWIwZGItZTg3NDA4NzNmZGQ0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLW15LWZpdG5lc3MiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiVVNFUiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6InF1b2NAZ21haWwuY29tIiwiZW1haWwiOiJxdW9jQGdtYWlsLmNvbSJ9.cy5cRWhXKV8ugSWSoDf3_hhk2i_epWuxzEIiLM8NbSmKGSYudmwfxgV0u4B8",
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
