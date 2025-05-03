import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class KeycloakService {
  static const String issuer = 'http://10.0.2.2:8888/realms/fitness-org';
  static const String clientId = 'flutter-app-client';
  static const String redirectUrl = 'com.fittrack.mobile:/callback';
  final String discoveryUrl =
      'http://10.0.2.2:8888/realms/fitness-org/.well-known/openid-configuration';
  static const List<String> scopes = ['openid', 'profile', 'email'];

  // final AuthorizationServiceConfiguration _serviceConfiguration =
  // AuthorizationServiceConfiguration(
  //   authorizationEndpoint:
  //   'http://10.0.2.2:8888/realms/fitness-org/protocol/openid-connect/auth',
  //   tokenEndpoint:
  //   'http://10.0.2.2:8888/realms/fitness-org/protocol/openid-connect/token',
  //   endSessionEndpoint:
  //   'http://10.0.2.2:8888/realms/fitness-org/protocol/openid-connect/logout',
  // );

  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();

  // Đăng nhập với Keycloak
  Future<bool> login() async {
    try {
      final AuthorizationTokenResponse? result =
      await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          //serviceConfiguration: _serviceConfiguration,
          scopes: scopes,
          discoveryUrl: discoveryUrl,
          //additionalParameters: {'code_challenge_method': 'S256'},
          //promptValues: ['login'],
          allowInsecureConnections: true,
        ),
      );

      print(">>>>>>>>>>>>> RESULT 1");
      print(result);

      if (result != null) {
        // Lưu token vào secure storage
        print(">>>>>>>>>>>>> RESULT 2");
        print('Access Token: ${result.accessToken}');
        print('Refresh Token: ${result.refreshToken}');
        print('ID Token: ${result.idToken}');
        print('Token Expiration: ${result.accessTokenExpirationDateTime}');
        await _storage.write(key: 'access_token', value: result.accessToken);
        await _storage.write(key: 'refresh_token', value: result.refreshToken);
        return true;
      }
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

      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          clientId,
          redirectUrl,
          issuer: issuer,
          refreshToken: refreshToken,
        ),
      );

      if (result != null) {
        await _storage.write(key: 'access_token', value: result.accessToken);
        await _storage.write(key: 'refresh_token', value: result.refreshToken);
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token error: $e');
      return false;
    }
  }

  // Gọi API với access token
  Future<dynamic> callApi(String endpoint) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      // Nếu không có access token, thử làm mới
      final bool refreshed = await refreshToken();
      if (!refreshed) {
        throw Exception('Unable to refresh token');
      }
      accessToken = await getAccessToken();
    }

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Nếu token hết hạn, thử làm mới và gọi lại
        final bool refreshed = await refreshToken();
        if (refreshed) {
          accessToken = await getAccessToken();
          final response = await _dio.get(
            endpoint,
            options: Options(
              headers: {'Authorization': 'Bearer $accessToken'},
            ),
          );
          return response.data;
        }
      }
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}

// import 'package:openid_client/openid_client_io.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:app_links/app_links.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:dio/dio.dart';
//
// class KeycloakService {
//   static const String issuer = 'http://10.0.2.2:8888/realms/fitness-org';
//   static const String clientId = 'flutter-app-client';
//   static const String redirectUrl = 'myapp://callback';
//   static const List<String> scopes = ['openid', 'profile'];
//
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//   final Dio _dio = Dio();
//   late final Client _client;
//   late final AppLinks _appLinks;
//   Credential? _credential; // Lưu trữ Credential để sử dụng cho refresh token
//
//   KeycloakService() {
//     _appLinks = AppLinks();
//   }
//
//   Future<void> initializeClient() async {
//     try {
//       final issuerObj = await Issuer.discover(Uri.parse(issuer));
//       _client = Client(issuerObj, clientId);
//     } catch (e) {
//       print('Error initializing client: $e');
//       rethrow;
//     }
//   }
//
//   Future<bool> login() async {
//     try {
//       await initializeClient();
//
//       // Tạo Authenticator với urlLancher tùy chỉnh
//       final authenticator = Authenticator(
//         _client,
//         scopes: scopes,
//         urlLancher: (url) async {
//           final uri = Uri.parse(url);
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//           } else {
//             throw 'Could not launch $url';
//           }
//         },
//         redirectUri: Uri.parse(redirectUrl),
//       );
//
//       // Sử dụng authorize() để bắt đầu flow đăng nhập và lấy Credential
//       _credential = await authenticator.authorize();
//       if (_credential != null) {
//         final tokenResponse = await _credential!.getTokenResponse();
//         print('Access token: ${tokenResponse.accessToken}');
//         print('Refresh token: ${tokenResponse.refreshToken}');
//         await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//         await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print('Login error: $e');
//       return false;
//     }
//   }
//
//   Future<String?> getAccessToken() async {
//     return await _storage.read(key: 'access_token');
//   }
//
//   Future<bool> refreshToken() async {
//     try {
//       final String? refreshToken = await _storage.read(key: 'refresh_token');
//       print('Refresh token: $refreshToken');
//       if (refreshToken == null || _credential == null) return false;
//
//       // Làm mới token bằng Credential
//       final tokenResponse = await _credential!.getTokenResponse();
//       print('New access token: ${tokenResponse.accessToken}');
//       await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//       await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//       return true;
//     } catch (e) {
//       print('Refresh token error: $e');
//       return false;
//     }
//   }
//
//   Future<dynamic> callApi(String endpoint) async {
//     String? accessToken = await getAccessToken();
//     print('Access token: $accessToken');
//     if (accessToken == null) {
//       final bool refreshed = await refreshToken();
//       if (!refreshed) {
//         throw Exception('Unable to refresh token');
//       }
//       accessToken = await getAccessToken();
//       print('New access token after refresh: $accessToken');
//     }
//
//     try {
//       print('Calling API: $endpoint');
//       final response = await _dio.get(
//         endpoint,
//         options: Options(
//           headers: {'Authorization': 'Bearer $accessToken'},
//         ),
//       );
//       print('API response: ${response.data}');
//       return response.data;
//     } on DioException catch (e) {
//       print('API error: $e');
//       if (e.response?.statusCode == 401) {
//         final bool refreshed = await refreshToken();
//         if (refreshed) {
//           accessToken = await getAccessToken();
//           final response = await _dio.get(
//             endpoint,
//             options: Options(
//               headers: {'Authorization': 'Bearer $accessToken'},
//             ),
//           );
//           return response.data;
//         }
//       }
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async {
//     await _storage.delete(key: 'access_token');
//     await _storage.delete(key: 'refresh_token');
//     _credential = null; // Xóa Credential khi đăng xuất
//   }
// }

// import 'package:openid_client/openid_client_io.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:dio/dio.dart';
//
// class KeycloakService {
//   static const String issuer = 'http://10.0.2.2:8888/realms/fitness-org';
//   static const String clientId = 'flutter-app-client';
//   static const String redirectUrl = 'myapp://callback';
//   static const List<String> scopes = ['openid'];
//
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//   final Dio _dio = Dio();
//   late final Client _client;
//   Credential? _credential;
//
//   KeycloakService();
//
//   Future<void> initializeClient() async {
//     try {
//       final issuerObj = await Issuer.discover(Uri.parse(issuer));
//       _client = Client(issuerObj, clientId);
//     } catch (e) {
//       print('Error initializing client: $e');
//       rethrow;
//     }
//   }
//
//   // Future<bool> login() async {
//   //   try {
//   //     await initializeClient();
//   //
//   //     final authenticator = Authenticator(
//   //       _client,
//   //       scopes: scopes,
//   //       urlLancher: (url) async {
//   //         final uri = Uri.parse(url);
//   //         print('Opening URL: $uri');
//   //         if (await canLaunchUrl(uri)) {
//   //           await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //         } else {
//   //           throw 'Could not launch $url';
//   //         }
//   //       },
//   //       redirectUri: Uri.parse(redirectUrl),
//   //     );
//   //
//   //
//   //
//   //     _credential = await authenticator.authorize();
//   //
//   //     print("--------------->");
//   //     if (_credential != null) {
//   //       final tokenResponse = await _credential!.getTokenResponse();
//   //       print('Access token: ${tokenResponse.accessToken}');
//   //       print('Refresh token: ${tokenResponse.refreshToken}');
//   //       await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//   //       await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//   //       return true;
//   //     }
//   //     return false;
//   //   } catch (e) {
//   //     print('Login error: $e');
//   //     return false;
//   //   }
//   // }
//
//   Future<bool> login() async {
//     try {
//       await initializeClient();
//
//       print('Creating Authenticator...');
//       final authenticator = Authenticator(
//         _client,
//         scopes: scopes,
//         urlLancher: (url) async {
//           final uri = Uri.parse(url);
//           print('Opening URL: $uri');
//           if (await canLaunchUrl(uri)) {
//             print('Launching URL...');
//             await launchUrl(uri, mode: LaunchMode.externalApplication);
//             print('URL launched successfully');
//           } else {
//             throw 'Could not launch $url';
//           }
//         },
//         redirectUri: Uri.parse(redirectUrl),
//       );
//
//       print('Authorizing...');
//       _credential = await authenticator.authorize();
//       print('Authorization completed');
//
//       if (_credential != null) {
//         final tokenResponse = await _credential!.getTokenResponse();
//         print('Access token: ${tokenResponse.accessToken}');
//         print('Refresh token: ${tokenResponse.refreshToken}');
//         await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//         await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//         return true;
//       }
//       print('Credential is null');
//       return false;
//     } catch (e) {
//       print('Login error: $e');
//       return false;
//     }
//   }
//
//   Future<String?> getAccessToken() async {
//     return await _storage.read(key: 'access_token');
//   }
//
//   Future<bool> refreshToken() async {
//     try {
//       final String? refreshToken = await _storage.read(key: 'refresh_token');
//       print('Refresh token: $refreshToken');
//       if (refreshToken == null || _credential == null) return false;
//
//       final tokenResponse = await _credential!.getTokenResponse();
//       print('New access token: ${tokenResponse.accessToken}');
//       await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//       await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//       return true;
//     } catch (e) {
//       print('Refresh token error: $e');
//       return false;
//     }
//   }
//
//   Future<dynamic> callApi(String endpoint) async {
//     String? accessToken = await getAccessToken();
//     print('Access token: $accessToken');
//     if (accessToken == null) {
//       final bool refreshed = await refreshToken();
//       if (!refreshed) {
//         throw Exception('Unable to refresh token');
//       }
//       accessToken = await getAccessToken();
//       print('New access token after refresh: $accessToken');
//     }
//
//     try {
//       print('Calling API: $endpoint');
//       final response = await _dio.get(
//         endpoint,
//         options: Options(
//           headers: {'Authorization': 'Bearer $accessToken'},
//         ),
//       );
//       print('API response: ${response.data}');
//       return response.data;
//     } on DioException catch (e) {
//       print('API error: $e');
//       if (e.response?.statusCode == 401) {
//         final bool refreshed = await refreshToken();
//         if (refreshed) {
//           accessToken = await getAccessToken();
//           final response = await _dio.get(
//             endpoint,
//             options: Options(
//               headers: {'Authorization': 'Bearer $accessToken'},
//             ),
//           );
//           return response.data;
//         }
//       }
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async {
//     await _storage.delete(key: 'access_token');
//     await _storage.delete(key: 'refresh_token');
//     _credential = null;
//   }
// }

// import 'dart:math';
//
// import 'package:openid_client/openid_client_io.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:app_links/app_links.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:dio/dio.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';
//
// class KeycloakService {
//   static const String issuer = 'http://10.0.2.2:8888/realms/fitness-org';
//   static const String clientId = 'flutter-app-client';
//   static const String redirectUrl = 'myapp://callback';
//   static const List<String> scopes = ['openid', 'profile', 'email'];
//
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();
//   final Dio _dio = Dio();
//   late final Client _client;
//   late final AppLinks _appLinks;
//   Credential? _credential;
//
//   KeycloakService() {
//     _appLinks = AppLinks();
//   }
//
//   Future<void> initializeClient() async {
//     try {
//       final issuerObj = await Issuer.discover(Uri.parse(issuer));
//       _client = Client(issuerObj, clientId);
//     } catch (e) {
//       print('Error initializing client: $e');
//       rethrow;
//     }
//   }
//
//   Future<bool> login() async {
//     try {
//       await initializeClient();
//
//       // Tạo flow thủ công
//       final flow = Flow.authorizationCode(_client);
//       flow.redirectUri = Uri.parse(redirectUrl);
//       flow.scopes.addAll(scopes);
//
//       // Tạo PKCE
//       final codeVerifier = base64UrlEncode(List<int>.generate(32, (i) => Random.secure().nextInt(256))).replaceAll('=', '');
//       final codeChallenge = base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes).replaceAll('=', '');
//
//       // Thêm PKCE vào URL đăng nhập
//       final authUrl = flow.authenticationUri
//           .replace(queryParameters: {
//         ...flow.authenticationUri.queryParameters,
//         'code_challenge': codeChallenge,
//         'code_challenge_method': 'S256',
//       });
//       print('Authorization URL: $authUrl');
//
//       // Mở URL
//       if (await canLaunchUrl(authUrl)) {
//         await launchUrl(authUrl, mode: LaunchMode.externalApplication);
//       } else {
//         throw 'Could not launch $authUrl';
//       }
//
//       // Chờ redirect URI
//       final uri = await _appLinks.uriLinkStream.firstWhere(
//             (uri) => uri != null && uri.toString().startsWith(redirectUrl),
//         orElse: () => throw Exception('No redirect URI received'),
//       );
//       print('Received redirect URI: $uri');
//
//       // Lấy Credential từ redirect URI
//       final response = flow.callback({
//         for (var e in uri.queryParameters.entries) e.key: e.value,
//         'code_verifier': codeVerifier, // Thêm code_verifier để trao đổi code
//       });
//       _credential = await response.first;
//       if (_credential != null) {
//         final tokenResponse = await _credential!.getTokenResponse();
//         print('Access token: ${tokenResponse.accessToken}');
//         print('Refresh token: ${tokenResponse.refreshToken}');
//         await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//         await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//         return true;
//       }
//       print('Credential is null');
//       return false;
//     } catch (e) {
//       print('Login error: $e');
//       return false;
//     }
//   }
//
//   Future<String?> getAccessToken() async {
//     return await _storage.read(key: 'access_token');
//   }
//
//   Future<bool> refreshToken() async {
//     try {
//       final String? refreshToken = await _storage.read(key: 'refresh_token');
//       print('Refresh token: $refreshToken');
//       if (refreshToken == null || _credential == null) return false;
//
//       final tokenResponse = await _credential!.getTokenResponse();
//       print('New access token: ${tokenResponse.accessToken}');
//       await _storage.write(key: 'access_token', value: tokenResponse.accessToken);
//       await _storage.write(key: 'refresh_token', value: tokenResponse.refreshToken);
//       return true;
//     } catch (e) {
//       print('Refresh token error: $e');
//       return false;
//     }
//   }
//
//   Future<dynamic> callApi(String endpoint) async {
//     String? accessToken = await getAccessToken();
//     print('Access token: $accessToken');
//     if (accessToken == null) {
//       final bool refreshed = await refreshToken();
//       if (!refreshed) {
//         throw Exception('Unable to refresh token');
//       }
//       accessToken = await getAccessToken();
//       print('New access token after refresh: $accessToken');
//     }
//
//     try {
//       print('Calling API: $endpoint');
//       final response = await _dio.get(
//         endpoint,
//         options: Options(
//           headers: {'Authorization': 'Bearer $accessToken'},
//         ),
//       );
//       print('API response: ${response.data}');
//       return response.data;
//     } on DioException catch (e) {
//       print('API error: $e');
//       if (e.response?.statusCode == 401) {
//         final bool refreshed = await refreshToken();
//         if (refreshed) {
//           accessToken = await getAccessToken();
//           final response = await _dio.get(
//             endpoint,
//             options: Options(
//               headers: {'Authorization': 'Bearer $accessToken'},
//             ),
//           );
//           return response.data;
//         }
//       }
//       rethrow;
//     }
//   }
//
//   Future<void> logout() async {
//     await _storage.delete(key: 'access_token');
//     await _storage.delete(key: 'refresh_token');
//     _credential = null;
//   }
// }

