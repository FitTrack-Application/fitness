import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  /// GET request with optional query parameters and headers
  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        Map<String, String>? headers,
      }) async {
    Uri uri = Uri.parse('$baseUrl/$endpoint');

    if (queryParams != null) {
      final stringQueryParams = queryParams.map(
            (key, value) => MapEntry(key, value.toString()),
      );
      uri = uri.replace(queryParameters: stringQueryParams);
    }

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API returned empty response');
        }

        try {
          return json.decode(response.body);
        } on FormatException {
          throw Exception('Invalid response format. Unable to parse JSON.');
        }
      } else {
        _handleHttpError(response);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not find the requested resource.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again later.');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// POST request with optional body and headers
  Future<dynamic> post(
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    try {
      final response = await http.post(
        uri,
        headers: requestHeaders,
        body: body != null ? json.encode(body) : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          try {
            return json.decode(response.body);
          } on FormatException {
            return {'success': true}; // Fallback
          }
        } else {
          return {'success': true}; // No content
        }
      } else {
        _handleHttpError(response);
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not find the requested resource.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again later.');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Custom error message handling
  void _handleHttpError(http.Response response) {
    String message;

    switch (response.statusCode) {
      case 400:
        message = 'Bad request. Please check your input.';
        break;
      case 401:
        message = 'Unauthorized. Please log in again.';
        break;
      case 403:
        message = 'Forbidden. You don\'t have permission to access this.';
        break;
      case 404:
        message = 'Resource not found.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = 'HTTP error ${response.statusCode}';
    }

    try {
      final errorBody = json.decode(response.body);
      if (errorBody is Map && errorBody.containsKey('message')) {
        message += ': ${errorBody['message']}';
      }
    } catch (_) {
      // Silent fallback
    }

    throw Exception('$message (Status code: ${response.statusCode})');
  }
}
