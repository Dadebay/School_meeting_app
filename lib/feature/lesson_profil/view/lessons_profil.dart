// ignore_for_file: inference_failure_on_function_invocation

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
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class LessonsProfil extends ConsumerStatefulWidget {
  const LessonsProfil(this.isTeacher, this.lessonID, {super.key});
  final bool isTeacher;
  final int lessonID;

  @override
  ConsumerState<LessonsProfil> createState() => _LessonsProfilState();
}

class _LessonsProfilState extends ConsumerState<LessonsProfil> {
  late LessonModel lessonModel;

  @override
  Widget build(BuildContext context) {
    lessonModel = ref.watch(lessonProvider).lessons.where((lesson) => lesson.id == widget.lessonID).first;
    ref.read(studentProvider.notifier).fetchStudents(lessonModel.id);
    bool isLessonCanceled = lessonModel.whyCanceled != 'null' && lessonModel.whyCanceled.isNotEmpty;
    bool isLessonPassed = lessonModel.past || CustomWidgets.compareTime(lessonModel.date.toString() + " " + lessonModel.endTime.toString());
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(context, isLessonPassed),
      appBar: _buildAppBar(context, isLessonCanceled, isLessonPassed),
      body: ListView(
        padding: context.padding.horizontalNormal,
        physics: const BouncingScrollPhysics(),
        children: [
          Text(lessonModel.lessonName, maxLines: 3, overflow: TextOverflow.ellipsis, style: context.general.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
          if (widget.isTeacher) _buildLessonStatus(context, isLessonCanceled, isLessonPassed),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(lessonModel.content, maxLines: 5, overflow: TextOverflow.ellipsis, style: context.general.textTheme.titleMedium?.copyWith(color: ColorConstants.greyColor)),
          ),
          CustomIconButton(lessonModel: lessonModel),
          Padding(
            padding: context.padding.verticalMedium,
            child: Text(LocaleKeys.lessons_classmates, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.general.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)).tr(),
          ),
          StudentCard(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isLessonCanceled, bool isLessonPassed) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: ColorConstants.whiteColor,
      scrolledUnderElevation: 0.0,
      actions: isLessonCanceled
          ? null
          : widget.isTeacher
              ? isLessonPassed
                  ? null
                  : [
                      TextButton(
                        onPressed: () => sendReasonForCancelLesson(context: context, lessonID: lessonModel.id),
                        child: Text(
                          LocaleKeys.general_cancel,
                          style: context.general.textTheme.titleMedium?.copyWith(
                            color: ColorConstants.redColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ).tr(),
                      )
                    ]
              : null,
    );
  }

  Future<void> sendReasonForCancelLesson({required BuildContext context, required int lessonID}) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius),
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
                  LocaleKeys.lessons_fill_cancel_lesson_blank,
                  style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                ).tr(),
                Padding(padding: context.padding.normal, child: CustomTextField(labelName: LocaleKeys.lessons_reason, controller: controller, maxLine: 5, focusNode: FocusNode(), requestfocusNode: FocusNode())),
                CustomButton(
                    text: LocaleKeys.general_send,
                    mini: true,
                    onPressed: () async {
                      await TeacherLessonsService().cancelLesson(lessonID, controller.text, context);
                      await refreshLessonData();
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> refreshLessonData() async {
    await LessonService.fetchLessonsForDate(DateTime.parse(lessonModel.date)).then((e) {
      ref.watch(lessonProvider.notifier).clearLessons(e);
    });
  }

  Widget _buildLessonStatus(BuildContext context, bool isLessonCanceled, bool isLessonPassed) {
    return Padding(
      padding: context.padding.onlyTopNormal,
      child: Text(
        LocaleKeys.lessons_lesson_status.tr() +
            ": " +
            (isLessonPassed
                ? LocaleKeys.lessons_past.tr()
                : (isLessonCanceled
                    ? LocaleKeys.lessons_lesson_canceled.tr()
                    : lessonModel.teacherConfirmation
                        ? LocaleKeys.general_confirmed.tr()
                        : LocaleKeys.lessons_not_confirmed.tr())),
        style: context.general.textTheme.titleLarge?.copyWith(
          color: isLessonCanceled ? ColorConstants.redColor : (lessonModel.teacherConfirmation ? ColorConstants.primaryBlueColor : ColorConstants.redColor),
          fontWeight: FontWeight.bold,
        ),
      ).tr(),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, bool isLessonPassed) {
    if (widget.isTeacher) {
      if (isLessonPassed) {
        return Container(
          margin: context.padding.normal,
          height: WidgetSizes.iconContainerSize.value,
          child: CustomButton(
            text: lessonModel.past ? LocaleKeys.lessons_students : LocaleKeys.lessons_attendence_lesson,
            onPressed: () => _onFloatingButtonPressed(context, isLessonPassed),
          ),
        );
      } else {
        return lessonModel.whyCanceled.toString() == 'null'
            ? null
            : Container(
                margin: context.padding.normal,
                height: WidgetSizes.iconContainerSize.value,
                child: CustomButton(
                  text: LocaleKeys.lessons_confirm,
                  onPressed: () => _onFloatingButtonPressed(context, isLessonPassed),
                ),
              );
      }
    }
    return Container(
      margin: context.padding.normal,
      height: WidgetSizes.iconContainerSize.value,
      child: CustomButton(
        text: widget.isTeacher ? LocaleKeys.lessons_confirm : LocaleKeys.lessons_cancel_lesson,
        onPressed: () => _onFloatingButtonPressed(context, isLessonPassed),
      ),
    );
  }

  void _onFloatingButtonPressed(BuildContext context, bool isLessonPassed) {
    if (widget.isTeacher) {
      if (isLessonPassed) {
        final selectedStudents = ref.watch(attendanceProvider);
        selectedStudents.clear();
        context.route.navigateToPage(StudentAttendancePageView(lessonModel: lessonModel, showAttendentStudents: lessonModel.past));
      } else {
        TeacherLessonsService().confirmLesson(lessonModel, context).then((value) async {
          if (value) {
            await refreshLessonData();
          }
        });
      }
    } else {
      Dialogs.showCancelLessonDialog(
        context: context,
        title: LocaleKeys.lessons_cancel_lesson,
        subtitle: LocaleKeys.lessons_cancel_subtitle,
        cancelText: LocaleKeys.general_agree,
        ontap: () {
          LessonService().cancelLessonStudent(lessonModel.id, context);
          CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.lessons_cancelled, ColorConstants.redColor);
        },
      );
    }
  }
}
