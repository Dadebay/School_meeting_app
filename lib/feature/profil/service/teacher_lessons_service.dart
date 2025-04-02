import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

class TeacherLessonsService {
  Future<bool> confirmLesson(LessonModel lesson, BuildContext context) async {
    final token = await AuthServiceStorage.getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.confirmLesson),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: {
        'lessonId': lesson.id.toString(),
        'noticeForStudents': 'Lesson confirmed: ${lesson.lessonName} - ${lesson.date} - ${lesson.content}',
      },
    );
    print(token);
    print(lesson.id.toString());
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.lessons_confirmed_lessons, ColorConstants.greenColor);
      return true;
    } else {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.general_emptyDataSubtitle, ColorConstants.redColor);
      return false;
    }
  }

  Future<Map<String, String>> cancelLesson(int lessonId, String reason, BuildContext context) async {
    final token = await AuthServiceStorage.getToken();
    Navigator.pop(context);
    final response = await http.post(
      Uri.parse(ApiConstants.cancelLessonTeacher + lessonId.toString() + "/"),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${token}',
      },
      body: {'why_canceled': reason},
    );
    log(ApiConstants.cancelLessonTeacher + lessonId.toString() + "/");
    if (response.statusCode == 200 || response.statusCode == 423) {
      return {};
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', 'Confirmation failed with status: ${response.statusCode}', ColorConstants.redColor);

      return {};
    }
  }

  static Future<String> fetchData({required bool privacy}) async {
    final response = await http.get(Uri.parse(privacy ? ApiConstants.privacyURL : ApiConstants.aboutusURL));
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final String data = json.decode(utf8Body)[0]['text'] as String;

      return data;
    } else {
      return '';
    }
  }
}
