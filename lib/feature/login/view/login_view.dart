import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/sizes/image_sizes.dart';
import 'package:okul_com_tm/product/widgets/custom_button.dart';
import 'package:okul_com_tm/product/widgets/custom_text_field.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
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
                  FlutterLogo(
                    size: ImageSizes.large.value,
                  ),
                  Padding(
                    padding: context.padding.verticalMedium,
                    child: Text(StringConstants.loginTitle, textAlign: TextAlign.center, style: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  Text(StringConstants.loginSubtitle, textAlign: TextAlign.center, style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomTextField(
                      labelName: StringConstants.emailAddress,
                      controller: userNameController,
                      prefixIcon: IconlyLight.message,
                      focusNode: userNameFocusNode,
                      requestfocusNode: passwordFocusNode,
                    ),
                  ),
                  CustomTextField(
                    labelName: StringConstants.passwordTitle,
                    controller: passwordController,
                    prefixIcon: IconlyLight.lock,
                    focusNode: passwordFocusNode,
                    requestfocusNode: userNameFocusNode,
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomButton(
                      text: StringConstants.agree,
                      mini: true,
                      removeShadow: true,
                      onPressed: () {
                        context.navigateTo(BottomNavBar(isTeacher: false));
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.navigateTo(BottomNavBar(isTeacher: true));
                      },
                      child: Text(StringConstants.forgotPassword, style: context.general.textTheme.bodyLarge?.copyWith(color: ColorConstants.greyColor)))
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
