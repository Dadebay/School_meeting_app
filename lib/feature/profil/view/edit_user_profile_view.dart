// ignore_for_file: must_be_immutable, inference_failure_on_function_invocation

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class EditUserProfileView extends ConsumerWidget {
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
      appBar: CustomAppBar(title: 'edit_profile', showBackButton: true),
      body: ListView(
        padding: context.padding.normal,
        children: [
          GestureDetector(
            onTap: () async {
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                state.image = File(image.path);
                userUpdate.updateProfile(
                  context: context,
                  userName: usernameController.text,
                  email: emailController.text,
                  image: state.image!,
                );
              }
            },
            child: Center(
              child: Stack(
                children: [
                  Container(
                    padding: context.padding.normal,
                    width: ImageSizes.large.value,
                    height: WidgetSizes.sliverAppBarHeightLessons.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.primaryBlueColor.withOpacity(.1),
                      border: Border.all(color: ColorConstants.blueColorwithOpacity),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.imageURL + state.imagePath,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider),
                        ),
                      ),
                      placeholder: (context, url) => CustomWidgets.loader(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                      bottom: 30,
                      right: 5,
                      child: Icon(
                        IconlyLight.edit_square,
                        color: ColorConstants.blackColor,
                      ))
                ],
              ),
            ),
          ),
          CustomTextField(
            labelName: 'Username',
            enabled: true,
            controller: usernameController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
          CustomTextField(
            labelName: 'Email',
            enabled: false,
            controller: emailController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
          Padding(
            padding: context.padding.verticalNormal,
            child: CustomButton(
              text: 'Change Password',
              mini: true,
              showBorderStyle: true,
              onPressed: () => showChangePasswordDialog(context),
            ),
          ),
          CustomButton(
            text: 'update_profile',
            mini: true,
            onPressed: () async {
              userUpdate.updateProfile(
                context: context,
                userName: usernameController.text,
                email: emailController.text,
                image: state.image!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChangePasswordDialog extends ConsumerWidget {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Change Password'),
      alignment: Alignment.center,
      titleTextStyle: context.general.textTheme.titleLarge!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            labelName: 'Current Password',
            enabled: true,
            controller: currentPasswordController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
          CustomTextField(
            labelName: 'New Password',
            enabled: true,
            controller: newPasswordController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
        ],
      ),
      actions: [
        CustomButton(
            text: 'agree',
            mini: true,
            onPressed: () {
              UserUpdateNotifier.changePassword(context: context, currentPassword: currentPasswordController.text, newPassword: newPasswordController.text);
            }),
        SizedBox(height: context.padding.low.vertical),
        CustomButton(
            text: 'cancel',
            showBorderStyle: true,
            mini: true,
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}

void showChangePasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ChangePasswordDialog(),
  );
}
