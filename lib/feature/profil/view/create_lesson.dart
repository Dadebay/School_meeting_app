import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lesson_provider.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/widgets/custom_app_bar.dart';
import 'package:okul_com_tm/product/widgets/custom_text_field.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CreateLessonView extends ConsumerWidget {
  TextEditingController lessonTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController instructorController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  FocusNode focusNodeLessonTitle = FocusNode();
  FocusNode focusNodeDescription = FocusNode();
  FocusNode focusNodeInstructor = FocusNode();
  FocusNode focusNodeLocation = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarNotifier = ref.watch(rescheduleProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Create Lesson', showBackButton: true),
      body: ListView(
        padding: context.padding.low,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: context.border.normalBorderRadius,
              side: BorderSide(
                width: 2,
                color: calendarNotifier.selectedDate == null ? ColorConstants.greyColor.withOpacity(.6) : ColorConstants.primaryBlueColor,
              ),
            ),
            title: Text(
              calendarNotifier.selectedDate == null ? StringConstants.selectDate : DateFormat('dd/MM/yyyy').format(calendarNotifier.selectedDate!),
              maxLines: 1,
              style: context.general.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: calendarNotifier.selectedDate == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
              ),
            ),
            trailing: Icon(IconlyLight.calendar, color: calendarNotifier.selectedDate == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              );
              if (pickedDate != null) {
                ref.read(rescheduleProvider.notifier).setDate(pickedDate);
              }
            },
          ),
          Padding(
            padding: context.padding.onlyTopNormal,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: context.border.normalBorderRadius,
                side: BorderSide(
                  width: 2,
                  color: calendarNotifier.selectedTime == null ? ColorConstants.greyColor.withOpacity(.6) : ColorConstants.primaryBlueColor,
                ),
              ),
              title: Text(
                calendarNotifier.selectedTime == null ? StringConstants.selectTime : calendarNotifier.selectedTime!.format(context),
                maxLines: 1,
                style: context.general.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: calendarNotifier.selectedTime == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
                ),
              ),
              trailing: Icon(IconlyLight.time_circle, color: calendarNotifier.selectedTime == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  ref.read(rescheduleProvider.notifier).setTime(pickedTime);
                }
              },
            ),
          ),
          CustomTextField(labelName: 'Lesson Title', controller: lessonTitleController, focusNode: focusNodeLessonTitle, requestfocusNode: focusNodeInstructor),
          CustomTextField(labelName: 'Instructor', controller: instructorController, focusNode: focusNodeInstructor, requestfocusNode: focusNodeLocation),
          CustomTextField(labelName: 'Class room', controller: locationController, focusNode: focusNodeLocation, requestfocusNode: focusNodeDescription),
          CustomTextField(labelName: 'Description', maxLine: 5, controller: descriptionController, focusNode: focusNodeDescription, requestfocusNode: focusNodeLessonTitle),
          SizedBox(height: context.padding.verticalNormal.vertical),
          CustomButton(text: 'Create lesson', onPressed: () {})
        ],
      ),
    );
  }
}
