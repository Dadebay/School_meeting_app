class UserModel {
  final String id;
  final String type;
  final String email;
  final String username;
  final String imagePath;

  UserModel({
    required this.id,
    required this.type,
    required this.email,
    required this.username,
    required this.imagePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      imagePath: json['img']?.toString() ?? '',
    );
  }
}
