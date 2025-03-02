import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/product/constants/index.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({required this.lessonModel, super.key});
  final LessonModel lessonModel;
  @override
  Widget build(BuildContext context) {
    Color color = ColorConstants.getRandomColor();
    return GestureDetector(
      onTap: () {
        context.navigateTo(LessonsProfil(
          lessonModel: lessonModel,
        ));
      },
      child: Container(
        margin: context.padding.low,
        decoration: BoxDecoration(
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
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: context.border.highBorderRadius,
                  color: color.withOpacity(.5),
                ),
                child: ClipRRect(borderRadius: context.border.highBorderRadius, child: CustomWidgets.imageWidget(lessonModel.img)),
              ),
            ),
            dateViewerCard(context),
            Positioned(
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
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(context.padding.normal),
                        elevation: WidgetStateProperty.all<double>(0),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: ColorConstants.primaryBlueColor.withOpacity(.5)),
                          ),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          StringConstants.joinLesson,
                          style: context.general.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.primaryBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned dateViewerCard(BuildContext context) {
    return Positioned(
      right: 15,
      top: 15,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.border.normalBorderRadius,
          color: ColorConstants.whiteColor,
        ),
        padding: context.padding.normal,
        width: 80,
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
                lessonModel.startTime.toString().substring(0, 5) + "\n" + lessonModel.endTime.toString().substring(0, 5),
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
}
