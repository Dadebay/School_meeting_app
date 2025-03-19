import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/lesson_profil/model/attendence_students_model.dart';

import '../../../product/widgets/index.dart';

class AttendanceNotifier extends StateNotifier<List<int>> {
  AttendanceNotifier() : super([]);

  void toggleStudent(int studentId) {
    if (state.contains(studentId)) {
      state = state.where((id) => id != studentId).toList();
    } else {
      state = [...state, studentId];
    }
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, List<int>>((ref) {
  return AttendanceNotifier();
});

class AttendenceService {
  Future<void> sendAttendance(List<int> selectedStudents, int lessonId, BuildContext context) async {
    final url = Uri.parse(ApiConstants.attendenceStudents + lessonId.toString() + '/');

    final token = await AuthServiceStorage.getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode({"students": selectedStudents}),
    );
    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, 'success', "attendence_submitted", ColorConstants.greenColor);
      context.route.pop();
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit_attendance", ColorConstants.redColor);
    }
  }

  static Future<List<AttendenceStudentsModel>> fetchAttendentStudents(int lessonId) async {
    final token = await AuthServiceStorage.getToken();

    final url = Uri.parse(ApiConstants.getAttendenceStudentsURL + lessonId.toString() + '/');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      return data.map((json) => AttendenceStudentsModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }
}
