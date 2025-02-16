import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/student_model.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.low,
      decoration: BoxDecoration(borderRadius: context.border.highBorderRadius, color: ColorConstants.greyColorwithOpacity),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1.3),
          itemCount: StudentModel.generateStudents().length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final StudentModel studentModel = StudentModel.generateStudents()[index];
            return Column(
              children: [
                Expanded(
                  child: Container(
                      padding: context.padding.normal,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(color: ColorConstants.whiteColor, shape: BoxShape.circle),
                      child: Image.asset(
                        studentModel.logo,
                      )),
                ),
                Text(
                  studentModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.general.textTheme.bodyLarge?.copyWith(color: ColorConstants.blackColor, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
    );
  }
}
