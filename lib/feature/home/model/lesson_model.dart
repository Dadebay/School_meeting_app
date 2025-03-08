// ignore_for_file: strict_raw_type

class LessonModel {
  final int id;
  final String lessonName;
  final String content;
  final String date;
  final String startTime;
  final String endTime;
  final bool teacherConfirmation;
  final bool past;
  final String teacher;
  final String classroom;
  final String img;
  final List students;

  LessonModel({
    required this.id,
    required this.lessonName,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.teacherConfirmation,
    required this.past,
    required this.teacher,
    required this.classroom,
    required this.img,
    required this.students,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as int? ?? 0,
      lessonName: json['lesson_name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      content: json['description']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      past: json['past'] as bool? ?? false,
      teacher: json['teacher']?.toString() ?? '',
      classroom: json['classroom']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      teacherConfirmation: json['teacherConfirmation'] as bool? ?? false,
      students: (json['students'] as List?)?.map((e) => e).toList() ?? [],
    );
  }
}

class StudentModel {
  final int id;
  final String username;
  final String email;
  final String img;

  StudentModel({
    required this.id,
    required this.username,
    required this.email,
    required this.img,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }
}
