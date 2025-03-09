// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/splash/service/fcm_provider.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class LoginView extends ConsumerWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: Image.asset(
          IconConstants.peakBackground,
          fit: BoxFit.cover,
        )),
        Center(
          child: SingleChildScrollView(
            child: Container(
              margin: context.padding.medium,
              padding: context.padding.normal,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: context.border.highBorderRadius,
                color: ColorConstants.whiteColor.withOpacity(.8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: Image.asset(
                      IconConstants.logo,
                      width: ImageSizes.high.value,
                    ),
                  ),
                  Text('login_subtitle'.tr(), textAlign: TextAlign.center, style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomTextField(
                      labelName: 'username'.tr(),
                      controller: userNameController,
                      prefixIcon: IconlyLight.profile,
                      focusNode: userNameFocusNode,
                      requestfocusNode: passwordFocusNode,
                    ),
                  ),
                  CustomTextField(
                    labelName: 'parol'.tr(),
                    controller: passwordController,
                    prefixIcon: IconlyLight.lock,
                    focusNode: passwordFocusNode,
                    requestfocusNode: userNameFocusNode,
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomButton(
                      text: 'agree'.tr(),
                      mini: true,
                      removeShadow: true,
                      onPressed: () async {
                        final username = userNameController.text;
                        final password = passwordController.text;
                        await ref.read(authProvider.notifier).login(username, password, context);
                        if (ref.read(authProvider).isLoggedIn) {
                          await FCMService.postFCMToken();
                          context.navigateTo(BottomNavBar());
                        } else {
                          userNameController.clear();
                          passwordController.clear();
                          CustomSnackbar.showCustomSnackbar(context, 'error_title'.tr(), 'login_title'.tr(), ColorConstants.redColor);
                        }
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        CustomSnackbar.showCustomSnackbar(context, 'contact'.tr(), 'contact_subtitle'.tr(), ColorConstants.redColor);
                      },
                      child: Text('forgot_password'.tr(), style: context.general.textTheme.bodyLarge?.copyWith(color: ColorConstants.greyColor)))
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
