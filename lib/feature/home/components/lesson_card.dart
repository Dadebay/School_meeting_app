import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({required this.lessonModel, required this.isTeacher, super.key});

  final LessonModel lessonModel;
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    final Color color = ColorConstants.getRandomColor();
    return GestureDetector(
      onTap: () => context.navigateTo(LessonsProfil(lessonID: lessonModel.id, isTeacher: isTeacher)),
      child: Container(
        margin: context.padding.low,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: context.border.highBorderRadius,
          border: Border.all(color: color),
          boxShadow: [BoxShadow(color: color.withOpacity(.5), blurRadius: 5, spreadRadius: 2)],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(borderRadius: context.border.highBorderRadius, color: color.withOpacity(.5)),
                child: ClipRRect(borderRadius: context.border.highBorderRadius, child: CustomWidgets.imageWidget(lessonModel.img, false)),
              ),
            ),
            _dateViewerCard(context),
            _lessonInfoCard(context),
          ],
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
        padding: context.padding.normal.copyWith(left: 5, right: 5),
        width: ImageSizes.normal.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateTime.parse(lessonModel.date).day.toString(),
              maxLines: 1,
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
    bool isLessonCanceled = lessonModel.whyCanceled != 'null' && lessonModel.whyCanceled.isNotEmpty;
    bool isTeacherConfirmed = lessonModel.teacherConfirmation;
    bool isNotConfirmed = !lessonModel.teacherConfirmation;
    Color buttonColor = _getButtonColor(isLessonCanceled, isTeacherConfirmed, isNotConfirmed);
    String buttonText = _getButtonText(isLessonCanceled, isNotConfirmed);
    return ElevatedButton(
      onPressed: () => context.navigateTo(LessonsProfil(lessonID: lessonModel.id, isTeacher: isTeacher)),
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(context.padding.normal),
        elevation: WidgetStateProperty.all<double>(0),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: ColorConstants.primaryBlueColor.withOpacity(.6)),
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          buttonText.tr(),
          style: context.general.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: _getTextColor(isLessonCanceled, isTeacherConfirmed, isNotConfirmed),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(bool isLessonCanceled, bool isTeacherConfirmed, bool isNotConfirmed) {
    if (isLessonCanceled) {
      return ColorConstants.redColor;
    } else if (isNotConfirmed) {
      return isTeacher ? ColorConstants.primaryBlueColor : Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  String _getButtonText(bool isLessonCanceled, bool isNotConfirmed) {
    if (isLessonCanceled) {
      return LocaleKeys.lessons_lesson_canceled;
    } else if (isNotConfirmed) {
      return isTeacher
          ? LocaleKeys.lessons_confirm
          : CustomWidgets.compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString())
              ? LocaleKeys.lessons_past
              : LocaleKeys.lessons_view_lesson;
    } else {
      return CustomWidgets.compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString()) ? LocaleKeys.lessons_past : LocaleKeys.lessons_view_lesson;
    }
  }

  Color _getTextColor(bool isLessonCanceled, bool isTeacherConfirmed, bool isNotConfirmed) {
    if (isLessonCanceled) {
      return ColorConstants.whiteColor;
    } else if (isNotConfirmed) {
      return isTeacher ? ColorConstants.whiteColor : ColorConstants.primaryBlueColor;
    } else {
      return CustomWidgets.compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString()) ? ColorConstants.greyColor : ColorConstants.primaryBlueColor;
    }
  }
}
