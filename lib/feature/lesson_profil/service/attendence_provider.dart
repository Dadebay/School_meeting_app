import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
    print(token);
    print(ApiConstants.attendenceStudents + lessonId.toString());
    print(selectedStudents);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, 'Success', "Attendance submitted successfully", ColorConstants.greenColor);
      context.route.pop();
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', "Failed to submit attendance", ColorConstants.redColor);
    }
  }
}
