// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';

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
    List<String> titles = [lessonModel.date.toString(), StringConstants.location, StringConstants.teacher];
    List<String> subTitles = [lessonModel.time.toString(), lessonModel.classLocation, lessonModel.teacher];
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
                ),
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
