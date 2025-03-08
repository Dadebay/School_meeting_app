import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/profil/service/teacher_lessons_service.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class LessonService {
  static Future<List<LessonModel>> fetchLessonsForDate(DateTime date) async {
    final token = await AuthServiceStorage.getToken();

    final url = Uri.parse(ApiConstants.getLessons);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: json.encode({
        'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      }),
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      return data.map((json) => LessonModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  Future<Map<String, String>> cancelLesson(int lessonId, BuildContext context) async {
    final token = await AuthServiceStorage.getToken();
    Navigator.pop(context);
    final response = await http.post(
      Uri.parse(ApiConstants.cancelLesson),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${token}',
      },
      body: {
        'lessonId': lessonId.toString(),
        'description': 'I am ill and cannot attend the lesson',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 423) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> decodedData = json.decode(utf8Body)[0] as Map<String, dynamic>;
      Dialogs.showCancelLessonDialog(
          context: context,
          title: decodedData['title'].toString(),
          subtitle: decodedData['description'].toString(),
          cancelText: StringConstants.agree,
          ontap: () {
            Navigator.pop(context);
          });
      return {};
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', 'Confirmation failed with status: ${response.statusCode}', ColorConstants.redColor);

      return {};
    }
  }

  Future<List<StudentModel>> fetchStudents(int id) async {
    final response = await http.get(Uri.parse(ApiConstants.getLesson + id.toString()));

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;

      return data.map((data) => StudentModel.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Failed to load students");
    }
  }

  Future<bool> confirmLesson(int lessonId, BuildContext context) async {
    final token = await AuthServiceStorage.getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.confirmLesson),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: {
        'lessonId': lessonId.toString(),
      },
    );

    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(
        context,
        'Succes',
        'Lessons successfully confirmed',
        ColorConstants.redColor,
      );
      return true;
    } else {
      CustomSnackbar.showCustomSnackbar(
        context,
        'Error',
        'Request failed with status: ${response.statusCode}',
        ColorConstants.redColor,
      );
      return false;
    }
  }
}

class LessonState {
  final DateTime selectedDate;
  final List<LessonModel> lessons;

  LessonState({required this.selectedDate, required this.lessons});

  LessonState copyWith({DateTime? selectedDate, List<LessonModel>? lessons}) {
    return LessonState(
      selectedDate: selectedDate ?? this.selectedDate,
      lessons: lessons ?? this.lessons,
    );
  }
}

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier() : super(LessonState(selectedDate: DateTime.now(), lessons: []));

  Future<void> fetchLessonsForDate(DateTime date) async {
    try {
      final String? status = await AuthServiceStorage.getStatus();
      final lessons = status == 'teacher' ? await TeacherLessonsService.fetchMyLessons() : await LessonService.fetchLessonsForDate(date);
      state = state.copyWith(selectedDate: date, lessons: lessons);
    } catch (e) {}
  }
}

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier();
});
