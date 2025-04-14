import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/product/widgets/index.dart';

class AuthServiceStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async => await _storage.write(key: 'auth_token', value: token);
  static Future<void> saveUserID(int userID) async => await _storage.write(key: 'user_id', value: userID.toString());
  static Future<void> saveStatus(String token) async => await _storage.write(key: 'status', value: token);

  static Future<String?> getUserID() async => await _storage.read(key: 'user_id');
  static Future<String?> getStatus() async => await _storage.read(key: 'status');
  static Future<String?> getToken() async => await _storage.read(key: 'auth_token');

  static Future<void> clearToken() async => await _storage.delete(key: 'auth_token');
  static Future<void> clearStatus() async => await _storage.delete(key: 'status');
}

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

  Future<dynamic> login(String username, String password) async {
    const storage = FlutterSecureStorage();
    final url = Uri.parse(ApiConstants.authUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      await AuthServiceStorage.saveUserID(int.parse(responseJson['user_id'].toString()));
      await AuthServiceStorage.saveToken(responseJson['access'].toString());
      await AuthServiceStorage.saveStatus(responseJson['user_type'].toString());
      state = state.copyWith(isLoggedIn: true, token: responseJson['access'].toString());
      return responseJson;
    } else {
      return null;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
