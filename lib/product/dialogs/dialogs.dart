// ignore_for_file: inference_failure_on_function_return_type, inference_failure_on_function_invocation, duplicate_ignore

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class Dialogs {
  static void showNoConnectionDialog({required VoidCallback onRetry, required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı dışarıya tıklayarak kapatamaz.
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: context.border.normalBorderRadius,
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                padding: context.padding.onlyTopNormal,
                child: Container(
                  padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    borderRadius: context.border.normalBorderRadius,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        StringConstants.noConnectionTitle,
                        style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Padding(
                        padding: context.padding.normal,
                        child: Text(
                          StringConstants.noConnectionSubtitle,
                          textAlign: TextAlign.center,
                          style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 19),
                        ),
                      ),
                      CustomButton(
                          text: StringConstants.onRetry,
                          onPressed: () {
                            Navigator.of(context).pop(); // Diyalogu kapat.
                            onRetry(); // Yeniden deneme işlemini çağır.
                          }),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: CircleAvatar(
                  backgroundColor: ColorConstants.whiteColor,
                  maxRadius: ImageSizes.small.value,
                  child: ClipOval(
                    child: Image.asset(
                      IconConstants.noConnection,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static sendReasonForCancelLesson({required BuildContext context}) {
    TextEditingController controller = TextEditingController();
    showDialog(
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
                  'Write rease why you want to cancel the lesson',
                  style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Padding(padding: context.padding.normal, child: CustomTextField(labelName: 'Reason', controller: controller, maxLine: 5, focusNode: FocusNode(), requestfocusNode: FocusNode())),
                CustomButton(
                    text: 'Send',
                    mini: true,
                    onPressed: () {
                      CustomSnackbar.showCustomSnackbar(context, "Success", "Your request has been sent ", ColorConstants.greenColor);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  static showCancelLessonDialog({required BuildContext context, required String title, required String subtitle, required String cancelText, required VoidCallback ontap}) {
    showDialog(
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
                  title,
                  style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 20),
                  ),
                ),
                CustomButton(text: cancelText, mini: true, onPressed: ontap),
              ],
            ),
          ),
        );
      },
    );
  }

  static logOut({required BuildContext context}) {
    // ignore: inference_failure_on_function_invocation
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        StringConstants.logOut,
                        style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: context.padding.onlyRightLow,
                          child: const Icon(CupertinoIcons.xmark_circle, color: ColorConstants.blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: Text(
                    StringConstants.logOutTitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.blackColor, fontSize: 19),
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: CustomButton(
                      text: 'yes'.tr(),
                      mini: true,
                      onPressed: () async {
                        await AuthServiceStorage.clearToken();
                        await AuthServiceStorage.clearStatus();
                        await Restart.restartApp();
                        CustomSnackbar.showCustomSnackbar(context, "Success", "Successfully logged out", ColorConstants.greenColor);
                      },
                      showBorderStyle: true),
                ),
                Padding(
                  padding: context.padding.normal.copyWith(top: 0),
                  child: CustomButton(
                      text: 'no'.tr(),
                      mini: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      showBorderStyle: false),
                ),
              ],
            ),
          );
        });
  }

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
