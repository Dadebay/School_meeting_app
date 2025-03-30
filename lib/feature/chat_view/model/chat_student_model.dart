class ChatStudentModel {
  final int id;
  final int conversationID;
  final String username;
  final String type;
  final String photo;

  ChatStudentModel({
    required this.id,
    required this.username,
    required this.conversationID,
    required this.type,
    required this.photo,
  });

  factory ChatStudentModel.fromJson(Map<String, dynamic> json) {
    return ChatStudentModel(
      id: json['user_id'] as int,
      username: json['username']?.toString() ?? '',
      conversationID: json['conv_id'] as int,
      type: json['type']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
    );
  }
}
