import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:okul_com_tm/feature/login/model/user_model.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

/// --------------------------
/// USER UPDATE STATE & NOTIFIER
/// --------------------------

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
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final UserModel data = UserModel.fromJson(json.decode(utf8Body)[0] as Map<String, dynamic>);
      setDetails(
        email: data.email ?? '',
        userName: data.username ?? '',
        image: File(data.imagePath ?? ''),
      );
      state = state.copyWith(
        email: data.email ?? '',
        username: data.username ?? '',
        imagePath: data.imagePath ?? '',
      );
      return data;
    } else {
      return null;
    }
  }

  static Future<void> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse(ApiConstants.changePassword);
    final token = await AuthServiceStorage.getToken();

    final response = await http.post(url, body: {
      'current_password': currentPassword,
      'new_password': newPassword,
    }, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(
        context,
        LocaleKeys.lessons_success,
        LocaleKeys.login_changed_success,
        Colors.green,
      );
      Navigator.pop(context);
    } else {
      CustomSnackbar.showCustomSnackbar(
        context,
        LocaleKeys.errors_title,
        LocaleKeys.login_incorrect_password,
        Colors.red,
      );
    }
  }

  void setUserName(String newUsername) {
    state = state.copyWith(username: newUsername);
  }

  void setAvatarIndex(int index) {
    state = state.copyWith(avatarIndex: index);
  }

  void setDetails({required String email, required String userName, required File image}) {
    state = state.copyWith(email: email, username: userName, image: image);
  }

  Future<void> updateProfile({
    required BuildContext context,
    required String userName,
    required String email,
  }) async {
    try {
      final token = await AuthServiceStorage.getToken();
      final url = Uri.parse(ApiConstants.updateProfile);
      var request = http.MultipartRequest('POST', url);

      request.fields['email'] = email;
      request.fields['username'] = userName;
      request.headers['Authorization'] = 'Bearer $token';

      // Asset avatar dosyasını Multipart olarak gönder
      if (state.avatarIndex != null) {
        final avatarPath = 'assets/icons/user${state.avatarIndex! + 1}.png';
        final byteData = await rootBundle.load(avatarPath);
        final bytes = byteData.buffer.asUint8List();

        final multipartFile = http.MultipartFile.fromBytes(
          'img',
          bytes,
          filename: 'avatar_user${state.avatarIndex! + 1}.png',
          contentType: MediaType('image', 'png'),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        CustomSnackbar.showCustomSnackbar(
          context,
          LocaleKeys.lessons_success,
          LocaleKeys.userProfile_profile_updated,
          ColorConstants.greenColor,
        );
        await getUserProfile();
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
  final String email;
  final String username;
  final File? image;
  final String imagePath;
  final int? avatarIndex;

  UserUpdateState({
    this.email = '',
    this.username = 'User',
    this.image,
    this.imagePath = '',
    this.avatarIndex,
  });

  UserUpdateState copyWith({
    String? email,
    String? username,
    File? image,
    String? imagePath,
    int? avatarIndex,
  }) {
    return UserUpdateState(
      email: email ?? this.email,
      username: username ?? this.username,
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }
}

/// --------------------------
/// AVATAR STATE (RIVERPOD)
/// --------------------------

final avatarProvider = StateNotifierProvider<AvatarNotifier, int>((ref) => AvatarNotifier());

class AvatarNotifier extends StateNotifier<int> {
  AvatarNotifier() : super(0);

  void setAvatar(int index) => state = index;
}

/// --------------------------
/// AVATAR DIALOG
/// --------------------------

void showAvatarDialog(BuildContext context, WidgetRef ref) {
  final List<String> avatars = List.generate(12, (index) => 'assets/icons/user${index + 1}.png');

  Widget buildAvatarItem(int index) {
    return CircleAvatar(
        backgroundColor: ColorConstants.primaryBlueColor.withOpacity(.3),
        radius: 62,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(avatars[index], fit: BoxFit.cover),
        ));
  }

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Consumer(
        builder: (context, ref, _) {
          final selectedAvatar = ref.watch(avatarProvider.notifier);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text("Choose Avatar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              CarouselSlider.builder(
                itemCount: avatars.length,
                itemBuilder: (context, index, realIndex) => buildAvatarItem(index),
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  viewportFraction: 0.5,
                  initialPage: ref.read(avatarProvider),
                  onPageChanged: (index, reason) {
                    selectedAvatar.setAvatar(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    text: "Set avatar",
                    onPressed: () async {
                      final userUpdate = ref.read(userUpdateProvider.notifier);
                      userUpdate.setAvatarIndex(ref.read(avatarProvider)); // seçilen index'i aktar

                      await userUpdate.updateProfile(
                        context: context,
                        userName: userUpdate.state.username,
                        email: userUpdate.state.email,
                      );

                      Navigator.of(context).pop();
                    }),
              )
            ],
          );
        },
      ),
    ),
  );
}
