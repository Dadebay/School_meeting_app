import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/login/model/user_model.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
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
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final UserModel data = UserModel.fromJson(json.decode(utf8Body)[0] as Map<String, dynamic>);
      final userData = data;
      setDetails(email: userData.email.toString(), userName: userData.username.toString(), image: File(userData.imagePath.toString()));
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

  static Future<void> changePassword({required BuildContext context, required String currentPassword, required String newPassword}) async {
    final url = Uri.parse(ApiConstants.changePassword);
    final token = await AuthServiceStorage.getToken();

    final response = await http.post(url, body: {
      'current_password': currentPassword,
      'new_password': newPassword,
    }, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.login_changed_success, Colors.green);
      Navigator.pop(context);
    } else {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.login_incorrect_password, Colors.red);
    }
  }

  void setUserName(String newUsername) {
    state = state.copyWith(username: newUsername);
  }

  void setDetails({required String email, required String userName, required File image}) {
    state = state.copyWith(email: email);
    state = state.copyWith(username: userName);
    state = state.copyWith(image: image);
  }

  Future<void> updateProfile({
    required BuildContext context,
    required String userName,
    required File image,
    required String email,
  }) async {
    try {
      final token = await AuthServiceStorage.getToken(); // Fetch the token
      final url = Uri.parse(ApiConstants.updateProfile);
      var request = http.MultipartRequest('POST', url);

      request.fields['email'] = email;
      request.fields['username'] = userName;
      request.headers['Authorization'] = 'Bearer $token';

      if (state.image != null) {
        var imageStream = http.ByteStream(state.image!.openRead());
        var length = await state.image!.length();
        var multipartFile = http.MultipartFile(
          'img',
          imageStream,
          length,
          filename: state.image!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      var response = await request.send();
      final responseBody = await response.stream.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        CustomSnackbar.showCustomSnackbar(
          context,
          LocaleKeys.lessons_success,
          LocaleKeys.userProfile_profile_updated,
          ColorConstants.greenColor,
        );
        await getUserProfile();
        setDetails(email: email, userName: userName, image: image);
      } else {
        CustomSnackbar.showCustomSnackbar(
          context,
          LocaleKeys.errors_title,
          LocaleKeys.userProfile_failed_to_update,
          ColorConstants.redColor,
        );
      }
    } catch (e) {
      CustomSnackbar.showCustomSnackbar(
        context,
        LocaleKeys.errors_title,
        LocaleKeys.userProfile_failed_to_update,
        ColorConstants.redColor,
      );
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
