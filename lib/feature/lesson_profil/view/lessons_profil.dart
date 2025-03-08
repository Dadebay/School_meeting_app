// ignore_for_file: unnecessary_null_comparison

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/custom_icon_button.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/student_card.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/attendence_provider.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/feature/lesson_profil/view/student_attendence_view.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class LessonsProfil extends ConsumerStatefulWidget {
  const LessonsProfil(this.lessonModel, this.isTeacher, {super.key});
  final LessonModel lessonModel;
  final bool isTeacher;
  @override
  ConsumerState<LessonsProfil> createState() => _LessonsProfilState();
}

class _LessonsProfilState extends ConsumerState<LessonsProfil> {
  List<StudentModel> studentList = [];

  @override
  void initState() {
    super.initState();
    fetcheData();
  }

  dynamic fetcheData() async {
    print(studentList);

    studentList = await LessonService().fetchStudents(widget.lessonModel.id);
    print(studentList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: ColorConstants.whiteColor,
      scrolledUnderElevation: 0.0,
      actions: widget.isTeacher ? [_buildCancelLessonButton(context)] : null,
    );
  }

  Widget _buildCancelLessonButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Dialogs.showCancelLessonDialog(
          context: context,
          title: "Cancel Lesson",
          subtitle: "Do you want to cancel the lesson?",
          cancelText: 'Agree',
          ontap: () {
            Navigator.of(context).pop();
            Dialogs.sendReasonForCancelLesson(context: context);
          },
        );
      },
      icon: Icon(
        IconlyBold.info_circle,
        color: ColorConstants.redColor,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: context.padding.horizontalNormal,
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          widget.lessonModel.lessonName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.general.textTheme.headlineLarge?.copyWith(
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.isTeacher)
          Padding(
            padding: context.padding.onlyTopNormal,
            child: Text(
              "Lesson Status : ${widget.lessonModel.teacherConfirmation.toString() == "true" ? "Confirmed" : "Not Confirmed"}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge?.copyWith(
                color: ColorConstants.primaryBlueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Padding(
          padding: context.padding.verticalNormal,
          child: Text(
            widget.lessonModel.content,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.titleMedium?.copyWith(
              color: ColorConstants.greyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        CustomIconButton(lessonModel: widget.lessonModel),
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
        StudentCard(
          lessonId: widget.lessonModel.id,
          students: studentList,
        ),
        SizedBox(height: context.padding.verticalHigh.vertical),
      ],
    );
  }

  bool compareTime(String timeString) {
    DateTime givenTime = DateTime.parse(timeString); // String'i DateTime'a çevir
    DateTime now = DateTime.now(); // Şu anki zamanı al
    if (givenTime.isBefore(now)) {
      return true;
    } else if (givenTime.isAfter(now)) {
      return false;
    } else {
      return false;
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (widget.isTeacher && widget.lessonModel.teacherConfirmation.toString() == "true") {
      if (compareTime(widget.lessonModel.date.toString() + " " + widget.lessonModel.endTime.toString())) {
        return Container(
          margin: context.padding.normal,
          height: WidgetSizes.iconContainerSize.value,
          child: CustomButton(
            text: "Attendence lesson",
            onPressed: () => _onFloatingButtonPressed(context),
          ),
        );
      } else {
        return null;
      }
    }
    return Container(
      margin: context.padding.normal,
      height: WidgetSizes.iconContainerSize.value,
      child: CustomButton(
        text: widget.isTeacher ? StringConstants.confirm : StringConstants.cancel,
        onPressed: () => _onFloatingButtonPressed(context),
      ),
    );
  }

  void _onFloatingButtonPressed(BuildContext context) {
    if (widget.isTeacher) {
      if (compareTime(widget.lessonModel.date.toString() + " " + widget.lessonModel.endTime.toString())) {
        final selectedStudents = ref.watch(attendanceProvider);
        selectedStudents.clear();
        context.route.navigateToPage(StudentAttendancePage(lessonId: widget.lessonModel.id, students: studentList));
      } else {
        LessonService().confirmLesson(widget.lessonModel.id, context);
      }
    } else {
      Dialogs.showCancelLessonDialog(
        context: context,
        title: "Cancel Lesson",
        subtitle: "Are you sure you want to cancel the lesson?",
        cancelText: StringConstants.yes,
        ontap: () => LessonService().cancelLesson(widget.lessonModel.id, context),
      );
    }
  }
}
