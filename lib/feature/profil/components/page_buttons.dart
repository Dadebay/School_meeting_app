import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class PageButtons extends StatelessWidget {
  final bool isTeacher;

  final List<String> buttonNames = [
    'Achievements',
    'Share app',
    "About Us",
    'Privacy Policy',
  ];

  final List<IconData> buttonIcons = [
    IconlyLight.discovery,
    IconlyLight.setting,
    IconlyLight.info_square,
    IconlyLight.document,
  ];

  final List<String> teacherButtonNames = [
    'Rooms Availability',
    'Create lesson',
    "About Us",
  ];

  final List<IconData> teacherButtonIcons = [
    IconlyLight.category,
    IconlyLight.paper_plus,
    IconlyLight.info_square,
  ];
  final List<String> teacherPages = ['/rooms', '/create_lesson'];

  final List<String> studentPages = [];
  // Doğru PageRouteInfo nesneleri ile değiştirin

  PageButtons({super.key, required this.isTeacher});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: isTeacher ? teacherButtonNames.length : buttonNames.length,
      padding: context.padding.normal,
      itemBuilder: (context, index) {
        return Padding(
          padding: context.padding.verticalLow,
          child: ListTile(
            onTap: () => context.router.pushNamed(isTeacher ? teacherPages[index] : studentPages[index]),
            shape: RoundedRectangleBorder(
              borderRadius: context.border.normalBorderRadius,
            ),
            tileColor: ColorConstants.greyColorwithOpacity.withOpacity(.8),
            contentPadding: context.padding.normal,
            leading: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.whiteColor.withOpacity(.6),
                border: Border.all(
                  color: ColorConstants.greyColor.withOpacity(.3),
                  width: 1,
                ),
              ),
              child: Icon(
                isTeacher ? teacherButtonIcons[index] : buttonIcons[index],
                color: ColorConstants.primaryBlueColor,
              ),
            ),
            title: Text(
              isTeacher ? teacherButtonNames[index].toString() : buttonNames[index].toString(),
              style: context.general.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
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
