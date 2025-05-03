import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/features/auth/services/keycloak_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final KeycloakService keycloakService = KeycloakService(); // dùng service có sẵn
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final data = response.data;
    if (data is Map<String, dynamic> && data['status'] == 401) {
      final isRefreshed = await keycloakService.refreshToken();
      if (isRefreshed) {
        final newAccessToken = await storage.read(key: 'access_token');

        try {
          final retryResponse = await dio.request(
            response.requestOptions.path,
            options: Options(
              method: response.requestOptions.method,
              headers: {
                ...response.requestOptions.headers,
                if (newAccessToken != null)
                  'Authorization': 'Bearer $newAccessToken',
              },
            ),
            data: response.requestOptions.data,
            queryParameters: response.requestOptions.queryParameters,
          );

          handler.resolve(retryResponse);
          return;
        } catch (retryError) {
          print("Retry failed: $retryError");
          await _logout();
        }
      } else {
        await _logout();
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err); // vẫn xử lý lỗi mạng như bình thường
  }

  Future<void> _logout() async {
    try {
      await keycloakService.logout(); // gọi hàm logout để revoke token server-side
    } catch (e) {
      print('Logout error: $e'); // vẫn tiếp tục nếu logout server lỗi
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/welcome',
          (route) => false,
    );
  }
}