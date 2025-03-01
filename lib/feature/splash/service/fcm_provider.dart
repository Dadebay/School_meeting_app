import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';

class FCMService {
  static Future<Map<String, dynamic>?> postFCMToken() async {
    final url = Uri.parse(ApiConstants.fcmPost);
    String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {'fcmToken': fcmToken};
    final bearerToken = await AuthServiceStorage.getToken();
    if (bearerToken != null) {
      print(bearerToken);
      headers['Authorization'] = 'Bearer $bearerToken';
    } else {
      print('Bearer token not found.');
      return null;
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      log(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
