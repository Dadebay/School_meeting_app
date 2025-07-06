import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart'; // bunu ekleyin
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/custom_icon_button.dart';
import 'package:okul_com_tm/feature/lesson_profil/components/student_card.dart';
import 'package:okul_com_tm/feature/lesson_profil/model/lesson_model.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/attendence_provider.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/feature/lesson_profil/view/student_attendence_view.dart';
import 'package:okul_com_tm/feature/profil/service/teacher_lessons_service.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(studentProvider.notifier).fetchStudents(widget.lessonID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonModel = ref.watch(lessonProvider).lessons.firstWhereOrNull((lesson) => lesson.id == widget.lessonID);
    if (lessonModel == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.router.canPop()) {
          Navigator.of(context).pop();
        }
      });
      return Scaffold(
        body: Center(child: CustomWidgets.loader()),
      );
    }
    final isLessonCanceled = lessonModel.whyCanceled != 'null' && lessonModel.whyCanceled.isNotEmpty;
    final isLessonPassed = lessonModel.past || CustomWidgets.compareTime("${lessonModel.date} ${lessonModel.endTime}");

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(context, lessonModel, isLessonCanceled, isLessonPassed),
      appBar: _buildAppBar(context, lessonModel, isLessonCanceled, isLessonPassed),
      body: _buildBody(context, lessonModel, isLessonCanceled, isLessonPassed),
    );
  }

  Widget _buildBody(BuildContext context, LessonModel lessonModel, bool isLessonCanceled, bool isLessonPassed) {
    return ListView(
      padding: context.padding.horizontalNormal,
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          lessonModel.lessonName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: context.general.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (widget.isTeacher)
          Padding(
            padding: context.padding.onlyTopNormal,
            child: _buildLessonStatus(context, lessonModel, isLessonCanceled, isLessonPassed),
          ),
        Padding(
          padding: context.padding.verticalNormal,
          child: Text(
            lessonModel.content,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.titleMedium?.copyWith(color: ColorConstants.greyColor),
          ),
        ),
        CustomIconButton(lessonModel: lessonModel),
        Padding(
          padding: context.padding.verticalMedium,
          child: Text(
            LocaleKeys.lessons_classmates,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.general.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ).tr(),
        ),
        StudentCard(),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, LessonModel lessonModel, bool isLessonCanceled, bool isLessonPassed) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: ColorConstants.whiteColor,
      scrolledUnderElevation: 0.0,
      actions: widget.isTeacher && !isLessonCanceled && !isLessonPassed
          ? [
              TextButton(
                onPressed: () => _showCancelDialog(context, lessonModel),
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

  Widget _buildLessonStatus(BuildContext context, LessonModel lessonModel, bool isLessonCanceled, bool isLessonPassed) {
    final statusText = isLessonPassed
        ? LocaleKeys.lessons_past
        : isLessonCanceled
            ? LocaleKeys.lessons_lesson_canceled
            : lessonModel.teacherConfirmation
                ? LocaleKeys.general_confirmed
                : LocaleKeys.lessons_not_confirmed;

    final statusColor = isLessonCanceled ? ColorConstants.redColor : (lessonModel.teacherConfirmation ? ColorConstants.primaryBlueColor : ColorConstants.redColor);

    return Text(
      '${LocaleKeys.lessons_lesson_status.tr()}: ${statusText.tr()}',
      style: context.general.textTheme.titleLarge?.copyWith(
        color: statusColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, LessonModel lessonModel, bool isLessonCanceled, bool isLessonPassed) {
    print(isLessonCanceled);
    print(isLessonPassed);
    print(lessonModel.teacherConfirmation);
    if (widget.isTeacher) {
      if (isLessonPassed) {
        return _buildFAB(context, lessonModel.past ? LocaleKeys.lessons_students : LocaleKeys.lessons_attendence_lesson, () {
          ref.watch(attendanceProvider).clear();
          context.route.navigateToPage(StudentAttendancePageView(
            lessonModel: lessonModel,
            showAttendentStudents: lessonModel.past,
          ));
        });
      } else {
        if (isLessonCanceled || lessonModel.teacherConfirmation == false) {
          return _buildFAB(context, LocaleKeys.lessons_confirm, () async {
            final success = await TeacherLessonsService().confirmLesson(lessonModel, context);
            if (success && mounted) {
              await _refreshLessonData(lessonModel);
            }
          });
        }
      }
    }
    return null;
  }

  Widget _buildFAB(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      margin: context.padding.normal,
      height: WidgetSizes.iconContainerSize.value,
      child: CustomButton(
        text: text,
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, LessonModel lessonModel) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: context.padding.normal,
          decoration: BoxDecoration(
            color: ColorConstants.whiteColor,
            borderRadius: context.border.normalBorderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.lessons_fill_cancel_lesson_blank,
                style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
              ).tr(),
              Padding(
                padding: context.padding.normal,
                child: CustomTextField(
                  labelName: LocaleKeys.lessons_reason,
                  controller: controller,
                  maxLine: 5,
                  focusNode: FocusNode(),
                  requestfocusNode: FocusNode(),
                ),
              ),
              CustomButton(
                text: LocaleKeys.general_send,
                mini: true,
                onPressed: () async {
                  final bool operationSucceeded = await TeacherLessonsService().cancelLesson(lessonModel.id, controller.text);
                  print(operationSucceeded);
                  print(operationSucceeded);
                  print(operationSucceeded);
                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;

                  if (operationSucceeded) {
                    _refreshLessonData(lessonModel);
                  } else {
                    CustomSnackbar.showCustomSnackbar(context, 'Error', 'Confirmation failed please try again', ColorConstants.redColor);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshLessonData(LessonModel lessonToRefresh) async {
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final DateTime lessonDate = format.parse(lessonToRefresh.date);
    final newLessons = await LessonService.fetchLessonsForDate(lessonDate);
    ref.read(lessonProvider.notifier).clearLessons(newLessons);
  }
}
