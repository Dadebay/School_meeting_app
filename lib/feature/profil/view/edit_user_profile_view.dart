// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
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
          Container(
            padding: context.padding.normal,
            width: ImageSizes.large.value,
            height: ImageSizes.large.value,
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
              text: 'change_image',
              showBorderStyle: true,
              mini: true,
              onPressed: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  state.image = File(image.path);
                  CustomSnackbar.showCustomSnackbar(context, 'success', "image_selected", ColorConstants.purpleColor);
                }
              },
            ),
          ),
          CustomButton(
            text: 'update_profile',
            mini: true,
            onPressed: () async {
              if (state.image != null) {
                userUpdate.updateProfile(
                  context: context,
                  userName: usernameController.text,
                  email: emailController.text,
                  image: state.image!,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
