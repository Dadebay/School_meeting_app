import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/product/constants/api_constants.dart';

class AuthServiceStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

final authServiceProvider = FutureProvider<bool>((ref) async {
  final token = await AuthServiceStorage.getToken();
  return token != null;
});

final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  const storage = FlutterSecureStorage();
  final isFirstLaunch = await storage.read(key: 'is_first_launch') == null;
  if (isFirstLaunch) {
    await storage.write(key: 'is_first_launch', value: 'false');
  }
  return isFirstLaunch;
});

class AuthState {
  final bool isLoggedIn;
  final String? token;

  AuthState({required this.isLoggedIn, this.token});

  AuthState copyWith({bool? isLoggedIn, String? token}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false));

  Future<void> login(String username, String password) async {
    try {
      final response = await AuthService.login(username, password);
      if (response != null) {
        await AuthServiceStorage.saveToken(response['access'].toString());
        state = state.copyWith(isLoggedIn: true, token: response['access'].toString());
      } else {
        // Hata durumu için uygun bir işlem yapın.
        print('Giriş başarısız.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<void> logout() async {
    await AuthServiceStorage.clearToken();
    state = state.copyWith(isLoggedIn: false, token: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthService {
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse(ApiConstants.authUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // API'nin istediği format
        'Accept': 'application/json', // Yanıt formatı
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    print('URL: $url');
    print('Username: $username');
    print('Password: $password');
    print('Response Body: ${response.body}');
    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
