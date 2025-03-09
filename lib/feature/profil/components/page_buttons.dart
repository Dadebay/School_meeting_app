import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/feature/profil/view/about_us_view.dart';
import 'package:okul_com_tm/feature/profil/view/free_time_managament_view.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class PageButtons extends ConsumerWidget {
  final bool isTeacher;

  final List<String> buttonNames = [
    'set_free_time',
    "about_us",
    'privacy_policy',
  ];

  final List<IconData> buttonIcons = [
    CupertinoIcons.time,
    IconlyLight.info_square,
    IconlyLight.document,
  ];

  PageButtons({super.key, required this.isTeacher});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: buttonNames.length,
      padding: context.padding.normal,
      itemBuilder: (context, index) {
        return isTeacher == true
            ? _buttons(context, index, ref)
            : buttonNames[index] == 'set_free_time'
                ? SizedBox.shrink()
                : _buttons(context, index, ref);
      },
    );
  }

  Padding _buttons(BuildContext context, int index, WidgetRef ref) {
    return Padding(
      padding: context.padding.verticalLow,
      child: ListTile(
        onTap: () {
          if (buttonNames[index] == 'set_free_time') {
            ref.read(freeTimesProvider.notifier).fetchFreeTimes(context);
            ref.read(dateRangeProvider.notifier).setDateRange(null);
            ref.read(timeRangeProvider.notifier).setTimeRange(null);
            context.route.navigateToPage(FreeTimeManagamentView());
          } else {
            context.route.navigateToPage(AboutUsView(
              privacyPolicy: buttonNames[index] == 'privacy_policy' ? true : false,
            ));
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
          buttonNames[index].toString().tr(),
          style: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(IconlyLight.arrow_right_circle, color: ColorConstants.greyColor),
      ),
    );
  }
}
