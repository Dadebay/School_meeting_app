import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/login/service/auth_provider.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/constants/widgets.dart';

class LessonService {
  static Future<List<LessonModel>> fetchLessonsForDate(DateTime date) async {
    final url = Uri.parse(ApiConstants.getLessons);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
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

  Future<bool> confirmLesson(int lessonId, String noticeForStudents, BuildContext context) async {
    final token = await AuthServiceStorage.getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.confirmLessons),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${token}',
      },
      body: {
        'lessonId': lessonId.toString(),
        'noticeForStudents': noticeForStudents,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', 'Confirmation failed with status: ${response.statusCode}', ColorConstants.redColor);

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
      print(date);
      print('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
      final lessons = await LessonService.fetchLessonsForDate(date);
      state = state.copyWith(selectedDate: date, lessons: lessons);
    } catch (e) {
      print('Error fetching lessons: $e');
    }
  }
}

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier();
});

final studentServiceProvider = Provider((ref) => StudentService());

class StudentService {
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
}
