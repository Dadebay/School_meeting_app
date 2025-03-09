// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class UserUpdateProfile extends ConsumerWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  state.image = File(image.path); // Seçilen resmi state içinde sakla
                }
              },
              child: Text('Pick Image'),
            ),
            CustomButton(
              text: 'Update Profile',
              onPressed: () async {
                if (state.image != null) {
                  print(state.image!.path);
                  userUpdate.setImage(state.image!);
                  await userUpdate.updateProfile(
                    context: context,
                    userName: usernameController.text,
                    email: emailController.text,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
