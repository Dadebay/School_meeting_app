import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lesson_provider.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';
import 'package:okul_com_tm/product/constants/string_constants.dart';
import 'package:okul_com_tm/product/widgets/custom_button.dart';

class Dialogs {
  void showRescheduleDialog(BuildContext context, WidgetRef ref) {
    final rescheduleNotifier = ref.read(rescheduleProvider.notifier);

    DateTime? tempSelectedDate;
    TimeOfDay? tempSelectedTime;
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                StringConstants.rescheduleLesson,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: context.border.normalBorderRadius,
                      side: BorderSide(
                        color: tempSelectedDate == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
                      ),
                    ),
                    title: Text(
                      tempSelectedDate == null ? StringConstants.selectDate : DateFormat('dd/MM/yyyy').format(tempSelectedDate!),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: context.general.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: tempSelectedDate == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
                      ),
                    ),
                    trailing: Icon(IconlyLight.calendar, color: tempSelectedDate == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          tempSelectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: context.border.normalBorderRadius,
                        side: BorderSide(
                          color: tempSelectedTime == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
                        ),
                      ),
                      title: Text(
                        tempSelectedTime == null ? StringConstants.selectTime : tempSelectedTime!.format(context),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: context.general.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tempSelectedTime == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor,
                        ),
                      ),
                      trailing: Icon(IconlyLight.time_circle, color: tempSelectedTime == null ? ColorConstants.greyColor : ColorConstants.primaryBlueColor),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            tempSelectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: StringConstants.description,
                      labelStyle: context.general.textTheme.titleMedium!.copyWith(
                        color: ColorConstants.greyColor,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: context.border.normalBorderRadius,
                        borderSide: BorderSide(color: ColorConstants.primaryBlueColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: context.border.normalBorderRadius,
                        borderSide: BorderSide(color: ColorConstants.primaryBlueColor),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: CustomButton(
                      text: StringConstants.send,
                      onPressed: () {
                        if (tempSelectedDate == null || tempSelectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select a date and time!")),
                          );
                        } else {
                          final String description = descriptionController.text;
                          rescheduleNotifier.setDate(tempSelectedDate!);
                          rescheduleNotifier.setTime(tempSelectedTime!);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
