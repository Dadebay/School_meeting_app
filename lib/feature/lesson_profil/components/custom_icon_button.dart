// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    super.key,
    required this.lessonModel,
  });
  final LessonModel lessonModel;

  List<IconData> icons = [
    IconlyLight.calendar,
    IconlyLight.location,
    IconlyLight.profile,
  ];
  List<Color> iconBackColors = [
    ColorConstants.blueColorwithOpacity,
    ColorConstants.purpleColorwithOpacity,
    ColorConstants.greenColorwithOpacity2,
  ];
  List<Color> iconColors = [
    ColorConstants.primaryBlueColor,
    ColorConstants.purpleColor,
    ColorConstants.greenColor,
  ];
  @override
  Widget build(BuildContext context) {
    List<String> titles = [lessonModel.date.toString(), LocaleKeys.lessons_classroom, LocaleKeys.lessons_teacher];
    List<String> subTitles = [lessonModel.startTime.toString().substring(0, 5) + " - " + lessonModel.endTime.toString().substring(0, 5), lessonModel.classroom.toString(), lessonModel.teacher.toString()];
    return Column(
        children: List.generate(icons.length, (index) {
      return Padding(
        padding: context.padding.verticalNormal,
        child: Row(
          children: [
            Container(
              width: WidgetSizes.iconContainerSize.value,
              height: WidgetSizes.iconContainerSize.value,
              margin: context.padding.onlyRightMedium,
              decoration: BoxDecoration(
                borderRadius: context.border.normalBorderRadius,
                color: iconBackColors[index],
              ),
              child: Icon(icons[index], color: iconColors[index], size: WidgetSizes.iconSize.value),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titles[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.general.textTheme.titleMedium?.copyWith(color: ColorConstants.greyColor, fontWeight: FontWeight.bold),
                ).tr(),
                Text(
                  subTitles[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.general.textTheme.titleLarge?.copyWith(color: ColorConstants.blackColor, fontWeight: FontWeight.bold),
                ),
              ],
            ))
          ],
        ),
      );
    }));
  }
}
