import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/widgets/widgets.dart';

import '../../home/model/lesson_model.dart';

class StudentCard extends StatelessWidget {
  final int lessonId;
  const StudentCard({super.key, required this.students, required this.lessonId});
  final List<StudentModel> students;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.low,
      decoration: BoxDecoration(
        borderRadius: context.border.highBorderRadius,
        color: ColorConstants.greyColorwithOpacity,
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1.3,
        ),
        itemCount: students.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final studentModel = students[index];
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: context.padding.normal,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: CustomWidgets.imageWidget(studentModel.img),
                ),
              ),
              Text(
                studentModel.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.general.textTheme.bodyLarge?.copyWith(
                  color: ColorConstants.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
