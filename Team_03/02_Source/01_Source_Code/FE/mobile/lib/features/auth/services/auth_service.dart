import 'dart:developer';
import 'package:mobile/cores/utils/dio/dio_client.dart';
import '../models/user_model.dart';
import '../models/response/api_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final dio = DioClient().dio;

  Future<ApiResponse> register(User user) async {
    try {
      final response = await dio.post(
        '/api/auth/register',
        data: user.toJson(),
      );

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        return ApiResponse(
          success: true,
          message: response.data['generalMessage'],
          data: response.data['data'],
          statusCode: response.data['status'] ?? 200,
        );
      } else {
        log('data: ${response.data['data']}');
        return ApiResponse(
          success: false,
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 400,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Đăng ký thất bại';

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }
      return ApiResponse(
        success: false,
        message: 'Lỗi kết nối: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse> checkAccount(String email) async {
    try {
      final response = await dio.post(
        '/api/auth/check-email',
        data: {
          'email': email,
        },
      );

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        return ApiResponse(
          success: true,
          message: response.data['generalMessage'],
          data: response.data['data'],
          statusCode: response.data['status'] ?? 200,
        );
      } else {
        log('data: ${response.data['data']}');
        return ApiResponse(
          success: false,
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 400,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        String errorMessage = 'Failed! ';

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }
      return ApiResponse(
        success: false,
        message: 'Network Error: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );


      print(">>>>>>>>>>>>>>>>>>>>>>>>>");
      print(response.data['data']);

      if (response.data['status'] == 200) {
        return ApiResponse(
          success: true,
          data: response.data['data'],
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed! ';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ApiResponse> getCurrentUser(String accessToken) async {
    try {
      final response = await dio.get('/auth/me');
      if (response.data['status'] == 200) {
        return ApiResponse(
          success: true,
          data: response.data['data'],
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unauthorized';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }

        return ApiResponse(
          success: false,
          message: errorMessage,
          statusCode: e.response!.statusCode ?? 400,
        );
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final response = await dio.get('/auth/sign-out');
      if (response.data['status'] == 200) {
        return ApiResponse(
          success: true,
          data: response.data['data'],
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['generalMessage'],
          statusCode: response.data['status'] ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unauthorized';
      if (e.response != null) {
        final errorData = e.response!.data;

        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          log('errorData: ${errorData['details']}');
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
