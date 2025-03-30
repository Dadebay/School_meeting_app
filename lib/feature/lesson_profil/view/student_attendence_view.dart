import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/attendence_students_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/attendence_provider.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class StudentAttendancePageView extends ConsumerWidget {
  final LessonModel lessonModel;
  final bool showAttendentStudents;
  const StudentAttendancePageView({
    super.key,
    required this.lessonModel,
    required this.showAttendentStudents,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentList = ref.watch(studentProvider);

    final selectedStudents = ref.watch(attendanceProvider);
    final appBarTitle = showAttendentStudents ? "attendent_students" : 'students';
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle, showBackButton: true),
      body: showAttendentStudents
          ? FutureBuilder<List<AttendenceStudentsModel>>(
              future: AttendenceService.fetchAttendentStudents(lessonModel.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomWidgets.loader();
                } else if (snapshot.hasError) {
                  return CustomWidgets.errorFetchData(context);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return CustomWidgets.emptyData(context);
                } else {
                  final studentsList = snapshot.data!;
                  return ListView.builder(
                    itemCount: studentsList.length,
                    padding: context.padding.onlyBottomHigh,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final student = studentsList[index];
                      return _studentCardAttendence(ref, student, context);
                    },
                  );
                }
              },
            )
          : ListView.builder(
              itemCount: studentList.length,
              padding: context.padding.normal,
              itemBuilder: (context, index) {
                final student = studentList[index];
                final isSelected = selectedStudents.contains(student.id);

                return _studentCard(ref, student, context, isSelected);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showAttendentStudents
          ? null
          : Container(
              margin: context.padding.normal,
              height: ImageSizes.small.value,
              child: CustomButton(
                  text: 'Send',
                  onPressed: () async {
                    if (selectedStudents.isEmpty) {
                      CustomSnackbar.showCustomSnackbar(context, 'error', 'select_student', ColorConstants.redColor);
                    } else {
                      AttendenceService().sendAttendance(selectedStudents.toList(), lessonModel.id, context);
                      ref.watch(lessonProvider.notifier).changePastStatus(lessonModel.id);
                    }
                  }),
            ),
    );
  }

  Widget _studentCardAttendence(WidgetRef ref, AttendenceStudentsModel student, BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopNormal.copyWith(left: 15),
      child: Row(
        children: [
          Container(
            width: ImageSizes.normal.value,
            height: ImageSizes.normal.value,
            padding: EdgeInsets.all(15),
            margin: context.padding.onlyRightNormal,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: ColorConstants.greyColorwithOpacity, spreadRadius: 3, blurRadius: 3)],
              border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
            ),
            child: CustomWidgets.imageWidget(student.img, false),
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
        ],
      ),
    );
  }

  GestureDetector _studentCard(WidgetRef ref, StudentModel student, BuildContext context, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(attendanceProvider.notifier).toggleStudent(student.id);
      },
      child: Padding(
        padding: context.padding.onlyTopNormal,
        child: Row(
          children: [
            Container(
              width: ImageSizes.normal.value,
              height: ImageSizes.normal.value,
              padding: EdgeInsets.all(15),
              margin: context.padding.onlyRightNormal,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: ColorConstants.greyColorwithOpacity, spreadRadius: 3, blurRadius: 3)],
                border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
              ),
              child: CustomWidgets.imageWidget(student.img, false),
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
            showAttendentStudents
                ? SizedBox.shrink()
                : Checkbox(
                    value: isSelected,
                    activeColor: ColorConstants.primaryBlueColor,
                    onChanged: (value) {
                      ref.read(attendanceProvider.notifier).toggleStudent(student.id);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
