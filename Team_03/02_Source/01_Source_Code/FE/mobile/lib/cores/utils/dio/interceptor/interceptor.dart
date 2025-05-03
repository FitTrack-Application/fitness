import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // Khai báo navigatorKey

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Thêm accessToken vào mỗi request
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/api/auth/refresh')) {
      // Thử làm mới accessToken
      final isTokenRefreshed = await _refreshAccessToken();
      if (isTokenRefreshed) {
        // Gửi lại request với accessToken mới
        try {
          final retryResponse = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          handler.resolve(retryResponse); // Trả về response mới
          return;
        } catch (retryError) {
          if (retryError is DioException) {
            handler.next(retryError); // Hoặc xử lý lại theo cách khác
            return;
          }
        }
      } else {
        // Nếu làm mới token không thành công, đăng xuất
        await _logout();
      }
    }
    handler.next(err); // Trả về lỗi nếu không xử lý được
  }

  Future<bool> _refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      try {
        // Gọi API POST /api/auth/refresh với refreshToken trong header
        final response = await dio.post(
          '/api/auth/refresh',
          options: Options(
            headers: {
              'Authorization': 'Bearer $refreshToken',
            },
          ),
        );

        if (response.data['status'] == 200) {
          // Parse response theo cấu trúc
          final newAccessToken = response.data['data']['accessToken'];
          await prefs.setString('accessToken', newAccessToken);
          return true;
        }
      } catch (e) {
        print('Error refreshing token: $e');
        return false;
      }
    }
    return false;
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    // Điều hướng về /welcome bằng navigatorKey
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/auth/login',
          (route) => false,
    );
  }
}