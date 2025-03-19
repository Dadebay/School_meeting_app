class AttendenceStudentsModel {
  final String username;
  final String img;
  final String attend;
  final String because_of_not_attendence;

  AttendenceStudentsModel({
    required this.username,
    required this.attend,
    required this.because_of_not_attendence,
    required this.img,
  });

  factory AttendenceStudentsModel.fromJson(Map<String, dynamic> json) {
    return AttendenceStudentsModel(
      username: json['student_username']?.toString() ?? '',
      attend: json['attend']?.toString() ?? '',
      because_of_not_attendence: json['becausoeofnotattendance']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }
}
