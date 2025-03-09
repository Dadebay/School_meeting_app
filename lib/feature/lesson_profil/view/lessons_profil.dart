// ignore_for_file: unnecessary_null_comparison

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/custom_icon_button.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/student_card.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/attendence_provider.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/feature/lesson_profil/view/student_attendence_view.dart';
import 'package:okul_com_tm/feature/profil/service/teacher_lessons_service.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class LessonsProfil extends ConsumerStatefulWidget {
  const LessonsProfil(this.lessonModelBack, this.isTeacher, {super.key});
  final LessonModel lessonModelBack;
  final bool isTeacher;
  @override
  ConsumerState<LessonsProfil> createState() => _LessonsProfilState();
}

class _LessonsProfilState extends ConsumerState<LessonsProfil> {
  late LessonModel lessonModel;

  @override
  void initState() {
    super.initState();
    changeLessonState();
    Future.microtask(() => ref.read(studentProvider.notifier).fetchStudents(widget.lessonModelBack.id));
  }

  dynamic changeLessonState() {
    // setState(() {
    print("mana geldi");
    lessonModel = widget.lessonModelBack;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final studentList = ref.watch(studentProvider);

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(context, studentList),
      appBar: _buildAppBar(context),
      body: _buildBody(context, studentList),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: ColorConstants.whiteColor,
      scrolledUnderElevation: 0.0,
      actions: lessonModel.whyCanceled.toString() == 'null'
          ? widget.isTeacher
              ? [_buildCancelLessonButton(context)]
              : null
          : null,
    );
  }

  dynamic sendReasonForCancelLesson({required BuildContext context, required int lessonID}) {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: true, // Kullanıcı dışarıya tıklayarak kapatamaz.
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.border.normalBorderRadius,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: context.padding.normal,
            decoration: BoxDecoration(
              color: ColorConstants.whiteColor,
              borderRadius: context.border.normalBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'fill_cancel_lesson_blank'.tr(),
                  style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Padding(padding: context.padding.normal, child: CustomTextField(labelName: 'reason'.tr(), controller: controller, maxLine: 5, focusNode: FocusNode(), requestfocusNode: FocusNode())),
                CustomButton(
                    text: 'Send',
                    mini: true,
                    onPressed: () async {
                      await TeacherLessonsService().cancelLesson(lessonID, controller.text, context);
                      final lessonState = ref.watch(lessonProvider);
                      await LessonService.fetchLessonsForDate(DateTime.parse(lessonModel.date)).then((e) {
                        lessonState.lessons = e;

                        e.forEach((element) {
                          print(element.id);
                          print(lessonModel.id.toString());
                          if (element.id.toString() == lessonModel.id.toString()) {
                            lessonModel = element;
                            setState(() {});

                            print("Asdasdasdasdasddqwdqbuhqbdoihqbowdihqbwoudhbqwoudhbqowhudbqowuhdboqwhbdoquhwbd");
                            print(lessonModel.whyCanceled);
                            print(element.whyCanceled);
                            return;
                          }
                        });
                      });
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelLessonButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        sendReasonForCancelLesson(context: context, lessonID: lessonModel.id);
      },
      child: Text(
        'cancel'.tr(),
        style: context.general.textTheme.titleMedium?.copyWith(
          color: ColorConstants.redColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<StudentModel> studentList) {
    return ListView(
      padding: context.padding.horizontalNormal,
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          lessonModel.lessonName,
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
              'lesson_status'.tr() +
                  ": " +
                  " ${lessonModel.whyCanceled.toString() == 'null' ? lessonModel.teacherConfirmation ? 'confirmed'.tr() : 'not_confirmed'.tr() : 'lesson_canceled'.tr()}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge?.copyWith(
                color: lessonModel.whyCanceled.toString() == 'null'
                    ? lessonModel.teacherConfirmation
                        ? ColorConstants.primaryBlueColor
                        : ColorConstants.redColor
                    : ColorConstants.redColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Padding(
          padding: context.padding.verticalNormal,
          child: Text(
            lessonModel.content,
            maxLines: 5,
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
            'classmates'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.headlineMedium?.copyWith(
              color: ColorConstants.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StudentCard(
          lessonId: lessonModel.id,
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

  Widget? _buildFloatingActionButton(BuildContext context, List<StudentModel> studentList) {
    if (widget.isTeacher && lessonModel.teacherConfirmation) {
      if (compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString())) {
        return Container(
          margin: context.padding.normal,
          height: WidgetSizes.iconContainerSize.value,
          child: CustomButton(
            text: 'attendence_lesson'.tr(),
            onPressed: () => _onFloatingButtonPressed(context, studentList),
          ),
        );
      } else {
        return lessonModel.whyCanceled.toString() == 'null'
            ? null
            : Container(
                margin: context.padding.normal,
                height: WidgetSizes.iconContainerSize.value,
                child: CustomButton(
                  text: 'confirm'.tr(),
                  onPressed: () => _onFloatingButtonPressed(context, studentList),
                ),
              );
      }
    }
    return Container(
      margin: context.padding.normal,
      height: WidgetSizes.iconContainerSize.value,
      child: CustomButton(
        text: widget.isTeacher ? 'confirm'.tr() : 'cancel_lesson'.tr(),
        onPressed: () => _onFloatingButtonPressed(context, studentList),
      ),
    );
  }

  void _onFloatingButtonPressed(BuildContext context, List<StudentModel> studentList) {
    if (widget.isTeacher) {
      if (compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString())) {
        final selectedStudents = ref.watch(attendanceProvider);
        selectedStudents.clear();
        context.route.navigateToPage(StudentAttendancePage(lessonId: lessonModel.id, students: studentList));
      } else {
        TeacherLessonsService().confirmLesson(lessonModel, context).then((value) async {
          if (value) {
            print("dasdadadasd__________________________________________________________________________________");
            final lessonState = ref.watch(lessonProvider);
            await LessonService.fetchLessonsForDate(DateTime.parse(lessonModel.date)).then((e) {
              lessonState.lessons = e;

              e.forEach((element) {
                print(element.id);
                if (element.id.toString() == lessonModel.id.toString()) {
                  lessonModel = element;

                  setState(() {});
                  return;
                }
              });
            });
          } else {}
        });
      }
    } else {
      Dialogs.showCancelLessonDialog(
        context: context,
        title: 'cancel_lesson'.tr(),
        subtitle: 'cancel_subtitle'.tr(),
        cancelText: 'agree'.tr(),
        ontap: () {
          LessonService().cancelLessonStudent(lessonModel.id, context);
          CustomSnackbar.showCustomSnackbar(context, 'success', 'cancelled'.tr(), ColorConstants.redColor);
        },
      );
    }
  }
}
