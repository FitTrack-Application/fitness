import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    Uri uri = Uri.parse('$baseUrl/$endpoint');

    if (queryParams != null) {
      // Convert all values to strings for URI parameters
      final stringQueryParams = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      uri = uri.replace(queryParameters: stringQueryParams);
    }

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Check if response body is empty
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
      if (e is Exception) {
        rethrow; // Rethrow already formatted exceptions
      }
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

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
        message =
            'Access forbidden. You don\'t have permission to access this resource.';
        break;
      case 404:
        message = 'Resource not found. The requested food may not exist.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = 'HTTP error ${response.statusCode}';
    }

    // Try to extract error message from response if available
    try {
      final errorBody = json.decode(response.body);
      if (errorBody is Map && errorBody.containsKey('message')) {
        message = '$message: ${errorBody['message']}';
      }
    } catch (_) {
      // If we can't parse the error body, just use the status message
    }

    throw Exception('$message (Status code: ${response.statusCode})');
  }

  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
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
        // Check if response body is not empty before parsing
        if (response.body.isNotEmpty) {
          try {
            return json.decode(response.body);
          } on FormatException {
            // Some successful requests might not return JSON
            return {'success': true};
          }
        } else {
          return {'success': true};
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
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
