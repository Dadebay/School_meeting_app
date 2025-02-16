import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class PageButtons extends StatelessWidget {
  List<String> buttonNames = [
    'Achievements',
    'Share app',
    "About Us",
    'Privacy Policy',
  ];
  List<IconData> buttonIcons = [
    IconlyLight.discovery,
    IconlyLight.setting,
    IconlyLight.info_square,
    IconlyLight.document,
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: buttonNames.length,
      padding: context.padding.normal,
      itemBuilder: (context, index) {
        return Padding(
          padding: context.padding.verticalLow,
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius),
            tileColor: ColorConstants.greyColorwithOpacity.withOpacity(.8),
            contentPadding: context.padding.normal,
            leading: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.whiteColor.withOpacity(.6),
                border: Border.all(color: ColorConstants.greyColor.withOpacity(.3), width: 1),
              ),
              child: Icon(
                buttonIcons[index],
                color: ColorConstants.primaryBlueColor,
              ),
            ),
            title: Text(
              buttonNames[index].toString(),
              style: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              IconlyLight.arrow_right_circle,
              color: ColorConstants.greyColor,
            ),
          ),
        );
      },
    );
  }
}
