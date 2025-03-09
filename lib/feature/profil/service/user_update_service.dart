import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/login/model/user_model.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

final userUpdateProvider = StateNotifierProvider<UserUpdateNotifier, UserUpdateState>((ref) {
  return UserUpdateNotifier();
});

class UserUpdateNotifier extends StateNotifier<UserUpdateState> {
  UserUpdateNotifier() : super(UserUpdateState());

  Future<UserModel?> getUserProfile() async {
    final token = await AuthServiceStorage.getToken();

    final url = Uri.parse(ApiConstants.getProfileData);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    print(token);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final UserModel data = UserModel.fromJson(json.decode(utf8Body)[0] as Map<String, dynamic>);
      final userData = data;
      state = state.copyWith(
        email: userData.email.toString(),
        username: userData.username.toString(),
        imagePath: userData.imagePath.toString(),
      );
      return userData;
    } else {
      return null;
    }
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setImage(File image) {
    state = state.copyWith(image: image);
  }

  Future<void> updateProfile({required BuildContext context, required String userName, required String email}) async {
    final token = await AuthServiceStorage.getToken(); // Fetch the token

    final url = Uri.parse(ApiConstants.updateProfile);
    var request = http.MultipartRequest('POST', url);

    request.fields['email'] = email;
    request.fields['username'] = userName;
    request.headers['Authorization'] = 'Bearer $token';
    print(request.fields['email'].toString());
    print(request.fields['username'].toString());
    if (state.image != null) {
      var imageStream = http.ByteStream(state.image!.openRead());
      var length = await state.image!.length();
      var multipartFile = http.MultipartFile('img', imageStream, length, filename: state.image!.path.split('/').last);
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, 'success', "Profile updated successfully", ColorConstants.greenColor);
      getUserProfile();

      Navigator.of(context).pop();
      print('Profile updated successfully');
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', "Failed to update profile", ColorConstants.redColor);
      print('Failed to update profile');
    }
  }
}

class UserUpdateState {
  String email;
  String username;
  File? image;
  String imagePath;

  UserUpdateState({this.email = '', this.username = '', this.image, this.imagePath = ''});

  UserUpdateState copyWith({String? email, String? username, File? image, String? imagePath}) {
    return UserUpdateState(
      email: email ?? this.email,
      username: username ?? this.username,
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
