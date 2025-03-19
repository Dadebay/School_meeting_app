import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/chat_view/model/chat_student_model.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class ChatService {
  static Future<List<ChatStudentModel>> fetchStudents() async {
    final String? status = await AuthServiceStorage.getStatus();
    final url = Uri.parse(status == 'teacher' ? ApiConstants.getAllForChatURL : ApiConstants.getStudentsForChatURL);
    print(status == 'teacher' ? ApiConstants.getAllForChatURL : ApiConstants.getStudentsForChatURL);
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      return data.map((json) => ChatStudentModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }
}

final studentProvider = FutureProvider<List<ChatStudentModel>>((ref) async {
  return ChatService.fetchStudents();
});
