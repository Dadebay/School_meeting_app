import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';

class TeacherLessonsService {
  static Future<List<LessonModel>> fetchMyLessons() async {
    final url = Uri.parse(ApiConstants.teacherLessons);
    final token = await AuthServiceStorage.getToken();
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      return data.map((json) => LessonModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load my lessons');
    }
  }
}
