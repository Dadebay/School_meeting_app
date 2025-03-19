class ChatStudentModel {
  final int id;
  final String username;
  final String email;
  final String img;

  ChatStudentModel({
    required this.id,
    required this.username,
    required this.email,
    required this.img,
  });

  factory ChatStudentModel.fromJson(Map<String, dynamic> json) {
    return ChatStudentModel(
      id: json['user_id'] as int,
      username: json['user__username']?.toString() ?? '',
      email: json['user__email']?.toString() ?? '',
      img: "/media/${json['img']?.toString() ?? ''}",
    );
  }
}
