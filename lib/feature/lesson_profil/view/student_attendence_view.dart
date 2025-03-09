import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/attendence_provider.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

import '../model/lesson_model.dart';

@RoutePage()
class StudentAttendancePage extends ConsumerWidget {
  final int lessonId;
  final List<StudentModel> students;
  const StudentAttendancePage({super.key, required this.students, required this.lessonId});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudents = ref.watch(attendanceProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Students', showBackButton: true),
      body: ListView.builder(
        itemCount: students.length,
        padding: context.padding.normal,
        itemBuilder: (context, index) {
          final student = students[index];
          final isSelected = selectedStudents.contains(student.id);

          return Padding(
            padding: context.padding.onlyTopNormal,
            child: Row(
              children: [
                Container(
                  width: ImageSizes.normal.value,
                  height: ImageSizes.normal.value,
                  padding: context.padding.low,
                  margin: context.padding.onlyRightNormal,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: ColorConstants.greyColorwithOpacity, spreadRadius: 3, blurRadius: 3)],
                    border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
                  ),
                  child: CustomWidgets.imageWidget(student.img),
                ),
                Expanded(
                  child: Text(
                    student.username,
                    textAlign: TextAlign.left,
                    style: context.general.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  activeColor: ColorConstants.primaryBlueColor,
                  onChanged: (value) {
                    ref.read(attendanceProvider.notifier).toggleStudent(student.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: context.padding.normal,
        height: ImageSizes.small.value,
        child: CustomButton(
            text: 'Send',
            onPressed: () {
              AttendenceService().sendAttendance(selectedStudents.toList(), lessonId, context);
            }),
      ),
      // FloatingActionButton(
      //   onPressed: () => AttendenceService().sendAttendance(selectedStudents.toList(), lessonId),
      //   child: const Icon(Icons.send),
      // ),
    );
  }
}
