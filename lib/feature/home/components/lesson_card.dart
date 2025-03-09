import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({required this.lessonModel, required this.isTeacher, super.key});

  final LessonModel lessonModel;
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    final Color color = ColorConstants.getRandomColor();
    return GestureDetector(
      onTap: () => _navigateToLesson(context),
      child: Container(
        margin: context.padding.low,
        decoration: _boxDecoration(color, context),
        child: Stack(
          children: [
            _backgroundImage(context, color),
            _dateViewerCard(context),
            _lessonInfoCard(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(Color color, BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: context.border.highBorderRadius,
      border: Border.all(color: color),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.5),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    );
  }

  Widget _backgroundImage(BuildContext context, Color color) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.border.highBorderRadius,
          color: color.withOpacity(.5),
        ),
        child: ClipRRect(
          borderRadius: context.border.highBorderRadius,
          child: CustomWidgets.imageWidget(lessonModel.img),
        ),
      ),
    );
  }

  Positioned _dateViewerCard(BuildContext context) {
    return Positioned(
      right: 15,
      top: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.border.normalBorderRadius,
          color: ColorConstants.whiteColor,
        ),
        padding: context.padding.normal,
        width: ImageSizes.normal.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateTime.parse(lessonModel.date).day.toString(),
              style: context.general.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.general.textTheme.headlineLarge?.fontSize,
              ),
            ),
            Padding(
              padding: context.padding.verticalLow,
              child: Text(
                "${lessonModel.startTime.toString().substring(0, 5)}\n${lessonModel.endTime.toString().substring(0, 5)}",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: context.general.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _lessonInfoCard(BuildContext context) {
    return Positioned(
      left: 15,
      bottom: 15,
      right: 15,
      child: Container(
        padding: context.padding.normal,
        decoration: BoxDecoration(
          color: ColorConstants.whiteColor.withOpacity(.9),
          borderRadius: context.border.normalBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessonModel.lessonName,
              maxLines: 2,
              style: context.general.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                lessonModel.content,
                maxLines: 3,
                style: context.general.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            _actionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _navigateToLesson(context),
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(context.padding.normal),
        elevation: WidgetStateProperty.all<double>(0),
        backgroundColor: WidgetStateProperty.all<Color>(
          lessonModel.whyCanceled.toString() == 'null'
              ? lessonModel.teacherConfirmation == false
                  ? (isTeacher ? ColorConstants.primaryBlueColor : Colors.transparent)
                  : Colors.transparent
              : ColorConstants.redColor,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: ColorConstants.primaryBlueColor.withOpacity(1)),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          lessonModel.whyCanceled.toString() == 'null'
              ? isTeacher
                  ? (lessonModel.teacherConfirmation ? 'view_lesson'.tr() : 'confirm'.tr())
                  : 'join_lesson'
              : 'lesson_canceled',
          style: context.general.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: lessonModel.whyCanceled.toString() == 'null'
                ? lessonModel.teacherConfirmation == false
                    ? (isTeacher ? ColorConstants.whiteColor : ColorConstants.primaryBlueColor)
                    : ColorConstants.primaryBlueColor
                : ColorConstants.whiteColor,
          ),
        ),
      ),
    );
  }

  void _navigateToLesson(BuildContext context) {
    context.navigateTo(
      LessonsProfil(
        lessonModel: lessonModel,
        isTeacher: isTeacher,
      ),
    );
  }
}
