import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class UserUpdateProfile extends ConsumerWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  File? myImage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUpdate = ref.watch(userUpdateProvider.notifier);
    final state = ref.watch(userUpdateProvider);
    emailController.text = state.email;
    usernameController.text = state.username;
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit profile', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              labelName: 'Email',
              controller: emailController,
              focusNode: FocusNode(),
              requestfocusNode: FocusNode(),
            ),
            CustomTextField(
              labelName: 'Username',
              enabled: false,
              controller: usernameController,
              focusNode: FocusNode(),
              requestfocusNode: FocusNode(),
            ),
            // Add image picker here
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final File file = File(image.path);
                  final compressedImage = await compressImage(file);
                  if (compressedImage != null) {
                    selectedImage = File(compressedImage.path);
                    state.image = selectedImage;
                  }
                }
              },
              child: Text('Pick Image'),
            ),
            CustomButton(
              text: 'Update Profile',
              onPressed: () async {
                print(state.image!.path);
                userUpdate.setImage(state.image!);
                await userUpdate.updateProfile(context: context, userName: usernameController.text, email: emailController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File selectedImage = File('');
  Future<XFile?> compressImage(File file) async {
    final int fileSizeInBytes = await file.length();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    final double fileSizeInKB = fileSizeInBytes / 1024;

    int quality = 70;

    if (fileSizeInMB < 5) {
      quality = 70; // Around 1 MB
    } else if (fileSizeInMB >= 5 && fileSizeInMB < 10) {
      quality = 50; // Around 2 MB
    } else {
      quality = 30; // Around 3 MB
    }

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path + '_compressed.jpg',
      quality: quality,
      minWidth: 1000,
      minHeight: 1000,
    );

    return compressedImage;
  }
}
