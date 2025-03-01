// ignore_for_file: unnecessary_null_comparison

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/custom_icon_button.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/student_card.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/custom_button.dart';

@RoutePage()
class LessonsProfil extends ConsumerWidget {
  const LessonsProfil({super.key, required this.lessonModel});
  final LessonModel lessonModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: context.padding.horizontalNormal,
        height: WidgetSizes.iconContainerSize.value,
        child: CustomButton(
          text: StringConstants.reschedule,
          onPressed: () {
            Dialogs().showRescheduleDialog(context, ref);
          },
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: ColorConstants.whiteColor,
        scrolledUnderElevation: 0.0,
      ),
      body: ListView(
        padding: context.padding.horizontalNormal,
        physics: BouncingScrollPhysics(),
        children: [
          Text(
            lessonModel.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.headlineLarge?.copyWith(
              color: ColorConstants.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              lessonModel.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleMedium?.copyWith(
                color: ColorConstants.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CustomIconButton(lessonModel: lessonModel),
          Padding(
            padding: context.padding.verticalMedium,
            child: Text(
              StringConstants.classmates,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.headlineMedium?.copyWith(
                color: ColorConstants.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StudentCard(),
          SizedBox(
            height: context.padding.verticalHigh.vertical,
          ),
        ],
      ),
    );
  }
}
