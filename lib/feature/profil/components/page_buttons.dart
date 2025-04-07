import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/feature/profil/view/about_us_view.dart';
import 'package:okul_com_tm/feature/profil/view/free_time_managament_view.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class PageButtons extends ConsumerWidget {
  final bool isTeacher;
  final bool isLoggedIN;

  final List<String> buttonNames = [
    LocaleKeys.userProfile_set_free_time,
    LocaleKeys.userProfile_about_us,
    LocaleKeys.userProfile_privacy_policy,
    LocaleKeys.userProfile_past_lessons,
  ];

  final List<IconData> buttonIcons = [
    CupertinoIcons.time,
    IconlyLight.info_square,
    IconlyLight.document,
    IconlyLight.time_circle,
  ];

  PageButtons({
    super.key,
    required this.isTeacher,
    required this.isLoggedIN,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(isLoggedIN);
    return ListView.builder(
      itemCount: buttonNames.length,
      padding: context.padding.normal,
      itemBuilder: (context, index) {
        if (!isTeacher && buttonNames[index] == LocaleKeys.userProfile_set_free_time) {
          return SizedBox.shrink();
        }

        if (index == buttonNames.length - 1 && isLoggedIN) {
          return _loginButton(context);
        }

        return _buttons(context, index, ref);
      },
    );
  }

  Padding _buttons(BuildContext context, int index, WidgetRef ref) {
    return Padding(
      padding: context.padding.verticalLow,
      child: ListTile(
        onTap: () {
          if (buttonNames[index] == LocaleKeys.userProfile_set_free_time) {
            ref.read(freeTimesProvider.notifier).fetchFreeTimes(context);
            context.route.navigateToPage(FreeTimeManagamentView());
          } else if (buttonNames[index] == LocaleKeys.userProfile_past_lessons) {
            context.navigateNamedTo('/pastLessons');
          } else {
            context.route.navigateToPage(
              AboutUsView(
                privacyPolicy: buttonNames[index] == LocaleKeys.userProfile_privacy_policy,
              ),
            );
          }
        },
        shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius),
        tileColor: ColorConstants.greyColorwithOpacity.withOpacity(.8),
        contentPadding: context.padding.normal,
        leading: Container(
          padding: context.padding.normal.copyWith(top: 15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.whiteColor.withOpacity(.6),
            border: Border.all(color: ColorConstants.greyColor.withOpacity(.3), width: 1),
          ),
          child: Icon(buttonIcons[index], color: ColorConstants.primaryBlueColor),
        ),
        title: Text(
          buttonNames[index],
          style: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        ).tr(),
        trailing: Icon(IconlyLight.arrow_right_circle, color: ColorConstants.greyColor),
      ),
    );
  }

  // 🔒 Login Button
  Padding _loginButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: ListTile(
        onTap: () {
          context.navigateNamedTo('/login');
        },
        shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius),
        tileColor: ColorConstants.greyColorwithOpacity.withOpacity(.8),
        contentPadding: context.padding.normal,
        leading: Container(
          padding: context.padding.normal.copyWith(top: 15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.whiteColor.withOpacity(.6),
            border: Border.all(color: ColorConstants.greyColor.withOpacity(.3), width: 1),
          ),
          child: Icon(IconlyLight.login, color: ColorConstants.primaryBlueColor),
        ),
        title: Text(
          'Login',
          style: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(IconlyLight.arrow_right_circle, color: ColorConstants.greyColor),
      ),
    );
  }
}
