import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/keycloak_service.dart';

class AuthViewModel extends ChangeNotifier {
  final KeycloakService _keycloakService = KeycloakService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool isLoading = false;
  String? error;

  // Gọi khi mở app để kiểm tra trạng thái đăng nhập
  Future<void> loadLoginState() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    _isLoggedIn = accessToken != null && refreshToken != null;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    notifyListeners();

    final result = await _keycloakService.login();

    _isLoggedIn = result;
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await _keycloakService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
