import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class KeycloakService {
  // static const String baseUrl = 'http://10.0.2.2:8888';
  static const String baseUrl = 'https://fitness-hcmus.cloud';
  static const String issuer = '$baseUrl/realms/my-fitness';
  static const String clientId = 'flutter-app-client';
  static const String redirectUrl = 'com.fittrack.mobile:/callback';
  final String discoveryUrl =
      '$baseUrl/realms/my-fitness/.well-known/openid-configuration';
  static const List<String> scopes = ['openid', 'profile', 'email'];

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  // Đăng nhập với Keycloak
  Future<bool> login() async {
    try {
      final AuthorizationTokenResponse result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          scopes: scopes,
          discoveryUrl: discoveryUrl,
          allowInsecureConnections: true,
        ),
      );

      // Lưu token vào secure storage
      print('Access Token: ${result.accessToken}');
      print('Refresh Token: ${result.refreshToken}');
      print('Token Expiration: ${result.accessTokenExpirationDateTime}');
      await _storage.write(key: 'access_token', value: result.accessToken);
      await _storage.write(key: 'refresh_token', value: result.refreshToken);
      return true;
          return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Lấy access token từ storage
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Làm mới token khi access token hết hạn
  Future<bool> refreshToken() async {
    try {
      final String? refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          refreshToken: refreshToken,
        ),
      );

      await _storage.write(key: 'access_token', value: result.accessToken);
      await _storage.write(key: 'refresh_token', value: result.refreshToken);
      return true;
          return false;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) return;

    final response = await _dio.post(
      '$baseUrl/realms/my-fitness/protocol/openid-connect/logout',
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {
        'client_id': clientId,
        'refresh_token': refreshToken,
      },
    );

    print('Logout response: ${response.statusCode}');

    // Xóa local token
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}