// ignore_for_file: must_be_immutable, inference_failure_on_function_invocation

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
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
    final userModel = ref.watch(userUpdateProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (emailController.text != state.email) emailController.text = state.email;
      if (usernameController.text != state.username) usernameController.text = state.username;
    });
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.userProfile_edit_profile, showBackButton: true),
      body: Column(
        children: [
          _page(context, ref, state, userUpdate),
          Padding(
            padding: context.padding.normal,
            child: CustomButton(
              text: LocaleKeys.userProfile_delete_account,
              mini: true,
              showBorderStyle: true,
              onPressed: () async {
                await AuthServiceStorage.clearToken();
                await AuthServiceStorage.clearStatus();
                UserUpdateNotifier().setUserName("");
                context.router.replaceNamed('/connectionCheckPage');
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded _page(BuildContext context, WidgetRef ref, UserUpdateState state, UserUpdateNotifier userUpdate) {
    return Expanded(
      child: ListView(
        padding: context.padding.normal,
        children: [
          GestureDetector(
            onTap: () async {
              showAvatarDialog(context, ref);
            },
            child: Center(
              child: Stack(
                children: [
                  Container(
                    padding: context.padding.medium,
                    width: ImageSizes.large.value,
                    height: WidgetSizes.sliverAppBarHeightLessons.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstants.primaryBlueColor.withOpacity(.1),
                      border: Border.all(color: ColorConstants.blueColorwithOpacity),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ApiConstants.imageURL + state.imagePath,
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: context.border.normalBorderRadius,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => CustomWidgets.loader(),
                      errorWidget: (context, url, error) => CustomWidgets.imagePlaceHolder(),
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
            labelName: LocaleKeys.login_username,
            enabled: true,
            controller: usernameController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
          CustomTextField(
            labelName: LocaleKeys.userProfile_email_address,
            enabled: false,
            controller: emailController,
            focusNode: FocusNode(),
            requestfocusNode: FocusNode(),
          ),
          Container(
            padding: context.padding.low.copyWith(left: 20),
            margin: context.padding.onlyTopNormal,
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.primaryBlueColor.withOpacity(.2)),
              borderRadius: context.border.normalBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.userProfile_userProfile_push_notifications,
                  style: context.general.textTheme.titleMedium!.copyWith(color: ColorConstants.greyColor),
                ).tr(),
                CupertinoSwitch(
                  value: state.pushNotificationsEnabled, // Bind to the local state field
                  activeColor: ColorConstants.primaryBlueColor, // Or your theme's active color
                  onChanged: (bool value) {
                    userUpdate.setLocalPushNotificationStatus(value, context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: context.padding.verticalNormal,
            child: CustomButton(
              text: LocaleKeys.login_change_password,
              mini: true,
              showBorderStyle: true,
              onPressed: () => showChangePasswordDialog(context),
            ),
          ),
          CustomButton(
            text: LocaleKeys.userProfile_update_profile,
            mini: true,
            onPressed: () async {
              await UserUpdateNotifier().updateProfile(
                context: context,
                userName: usernameController.text,
                email: emailController.text,
              );

              ref.read(userUpdateProvider.notifier).setUserName(usernameController.text);

              context.route.pop();
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
    return Dialog(
      insetPadding: EdgeInsets.all(15),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.login_change_password,
              style: context.general.textTheme.titleLarge!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ).tr(),
            SizedBox(height: 20),
            CustomTextField(
              labelName: LocaleKeys.login_current_password,
              enabled: true,
              controller: currentPasswordController,
              focusNode: FocusNode(),
              requestfocusNode: FocusNode(),
            ),
            CustomTextField(
              labelName: LocaleKeys.login_new_password,
              enabled: true,
              isPassword: true,
              controller: newPasswordController,
              focusNode: FocusNode(),
              requestfocusNode: FocusNode(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: context.padding.verticalLow,
              child: CustomButton(
                  text: LocaleKeys.userProfile_accept,
                  mini: true,
                  onPressed: () {
                    UserUpdateNotifier.changePassword(context: context, currentPassword: currentPasswordController.text, newPassword: newPasswordController.text);
                  }),
            ),
            CustomButton(
                text: LocaleKeys.general_cancel,
                showBorderStyle: true,
                mini: true,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}

void showChangePasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ChangePasswordDialog(),
  );
}
