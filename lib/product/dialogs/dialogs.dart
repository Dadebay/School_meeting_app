// ignore_for_file: inference_failure_on_function_return_type, inference_failure_on_function_invocation, duplicate_ignore

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okul_com_tm/core/routes/route.gr.dart';
import 'package:okul_com_tm/feature/profil/components/custom_time_picker.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/feature/profil/service/user_update_service.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';

enum RecurrenceType { none, workweek, weekly, monthly }

class Dialogs {
  Future<void> showReportDialog(BuildContext context, String username) async {
    final TextEditingController _reportController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report User'),
          content: TextField(
            controller: _reportController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Please describe why you are reporting this user...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Send'),
              onPressed: () async {
                final reason = _reportController.text.trim();
                if (reason.isNotEmpty) {
                  final emailUri = Uri(
                    scheme: 'mailto',
                    path: 'info@musicacademykc.com',
                    query: Uri.encodeFull('subject=Report User ${username}&body=$reason'),
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  } else {
                    Clipboard.setData(ClipboardData(text: reason));
                    CustomSnackbar.showCustomSnackbar(
                      context,
                      LocaleKeys.errors_title,
                      "Could not open email app. Message copied to clipboard.",
                      ColorConstants.redColor,
                    );
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showNoConnectionDialog({required VoidCallback onRetry, required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                        LocaleKeys.general_noConnectionTitle,
                        style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ).tr(),
                      Padding(
                        padding: context.padding.normal,
                        child: Text(
                          LocaleKeys.general_noConnectionSubtitle,
                          textAlign: TextAlign.center,
                          style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 19),
                        ).tr(),
                      ),
                      CustomButton(
                          text: LocaleKeys.general_retry,
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

  static showCancelLessonDialog({required BuildContext context, required String title, required String subtitle, required String cancelText, required VoidCallback ontap}) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                ).tr(),
                Padding(
                  padding: context.padding.normal,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyMedium!.copyWith(fontSize: 20),
                  ).tr(),
                ),
                CustomButton(text: cancelText, mini: true, onPressed: ontap),
              ],
            ),
          ),
        );
      },
    );
  }

  static showDateTimePicker(BuildContext context, WidgetRef ref) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateRange == null) return;

    TimeOfDay selectedStartTime = TimeOfDay.now();
    TimeOfDay selectedEndTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: context.padding.horizontalNormal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: context.padding.medium,
                    child: Text(LocaleKeys.userProfile_select_time, style: context.general.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)).tr(),
                  ),
                  CustomTimePicker(
                    initialTime: selectedStartTime,
                    text: 'Starts',
                    onTimeSelected: (time) => setState(() => selectedStartTime = time),
                  ),
                  CustomTimePicker(
                    text: 'Ends',
                    initialTime: selectedEndTime,
                    onTimeSelected: (time) => setState(() => selectedEndTime = time),
                  ),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: ElevatedButton(
                        onPressed: () {
                          final DateTime startDateTime = DateTime(
                            pickedDateRange.start.year,
                            pickedDateRange.start.month,
                            pickedDateRange.start.day,
                            selectedStartTime.hour,
                            selectedStartTime.minute,
                          );

                          final DateTime endDateTime = DateTime(
                            pickedDateRange.end.year,
                            pickedDateRange.end.month,
                            pickedDateRange.end.day,
                            selectedEndTime.hour,
                            selectedEndTime.minute,
                          );

                          if (endDateTime.isBefore(startDateTime)) {
                            CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.userProfile_start_time_should_be_before_end_time, ColorConstants.redColor);
                            return;
                          }

                          Navigator.pop(context);
                          showRecurrenceDialog(context, ref, startDateTime, endDateTime);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.primaryBlueColor, elevation: 0.0, padding: context.padding.normal, side: BorderSide(color: ColorConstants.primaryBlueColor), shape: RoundedRectangleBorder(borderRadius: context.border.lowBorderRadius)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            LocaleKeys.general_confirm,
                            textAlign: TextAlign.center,
                            style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
                          ).tr(),
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: ColorConstants.greyColorwithOpacity, elevation: 0.0, padding: context.padding.normal, side: BorderSide(color: ColorConstants.greyColor), shape: RoundedRectangleBorder(borderRadius: context.border.lowBorderRadius)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          LocaleKeys.general_cancel,
                          textAlign: TextAlign.center,
                          style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.greyColor, fontWeight: FontWeight.bold),
                        ).tr(),
                      )),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  static showRecurrenceDialog(BuildContext context, WidgetRef ref, DateTime start, DateTime end) {
    RecurrenceType recurrenceType = RecurrenceType.none;
    List<int> selectedWeekDays = [];
    List<int> selectedMonths = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget chipButton({
              required BuildContext context,
              required String text,
              required RecurrenceType type,
              required RecurrenceType selectedType,
              required Function(RecurrenceType) onSelected,
            }) {
              return Padding(
                padding: context.padding.verticalLow,
                child: ChoiceChip(
                  label: Text(
                    text,
                    style: context.general.textTheme.bodyLarge!.copyWith(
                      fontWeight: type == selectedType ? FontWeight.bold : FontWeight.w300,
                      color: type == selectedType ? ColorConstants.whiteColor : ColorConstants.blackColor,
                    ),
                  ).tr(),
                  selected: type == selectedType,
                  showCheckmark: false,
                  disabledColor: ColorConstants.greenColorwithOpacity,
                  selectedColor: ColorConstants.primaryBlueColor,
                  onSelected: (selected) => onSelected(selectedType),
                ),
              );
            }

            return AlertDialog(
              insetPadding: context.padding.horizontalNormal,
              title: Center(
                child: Text(
                  LocaleKeys.userProfile_select_recurrence,
                  style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ).tr(),
              ),
              actionsAlignment: MainAxisAlignment.end,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start Date : ${DateFormat('yyyy-MM-dd hh:mm a').format(start)}",
                    maxLines: 1,
                    style: context.general.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: Text(
                      "End Date :  ${DateFormat('yyyy-MM-dd hh:mm a').format(end)}",
                      maxLines: 1,
                      style: context.general.textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.greyColor,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      chipButton(
                        context: context,
                        text: LocaleKeys.userProfile_workweek_only,
                        type: recurrenceType,
                        selectedType: RecurrenceType.workweek,
                        onSelected: (type) => setState(() => recurrenceType = type),
                      ),
                      chipButton(
                        context: context,
                        text: LocaleKeys.userProfile_repeat_weekly,
                        type: recurrenceType,
                        selectedType: RecurrenceType.weekly,
                        onSelected: (type) => setState(() => recurrenceType = type),
                      ),
                      chipButton(
                        context: context,
                        text: LocaleKeys.userProfile_repeat_monthly,
                        type: recurrenceType,
                        selectedType: RecurrenceType.monthly,
                        onSelected: (type) => setState(() => recurrenceType = type),
                      ),
                    ],
                  ),
                  if (recurrenceType == RecurrenceType.weekly)
                    Padding(
                      padding: context.padding.normal,
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: List.generate(7, (index) {
                          return ChoiceChip(
                            label: Text(
                              ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                              style: context.general.textTheme.bodyLarge!.copyWith(
                                fontWeight: selectedWeekDays.contains(index) ? FontWeight.bold : FontWeight.w300,
                                color: selectedWeekDays.contains(index) ? ColorConstants.whiteColor : ColorConstants.blackColor,
                              ),
                            ),
                            showCheckmark: false,
                            disabledColor: ColorConstants.greenColorwithOpacity,
                            selectedColor: ColorConstants.primaryBlueColor,
                            selected: selectedWeekDays.contains(index),
                            onSelected: (selected) {
                              setState(() {
                                if (selectedWeekDays.contains(index)) {
                                  selectedWeekDays.remove(index);
                                } else {
                                  selectedWeekDays.add(index);
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ),
                  if (recurrenceType == RecurrenceType.monthly)
                    Padding(
                      padding: context.padding.verticalLow,
                      child: Wrap(
                        spacing: 5,
                        children: List.generate(12, (index) {
                          int newIndex = index + 1;
                          return ChoiceChip(
                            label: Text(
                              DateFormat('MMM').format(DateTime(0, newIndex)),
                              style: context.general.textTheme.bodyLarge!.copyWith(
                                fontWeight: selectedMonths.contains(newIndex) ? FontWeight.bold : FontWeight.w300,
                                color: selectedMonths.contains(newIndex) ? ColorConstants.whiteColor : ColorConstants.blackColor,
                              ),
                            ),
                            selected: selectedMonths.contains(newIndex),
                            showCheckmark: false,
                            disabledColor: ColorConstants.greenColorwithOpacity,
                            selectedColor: ColorConstants.primaryBlueColor,
                            onSelected: (selected) {
                              setState(() {
                                if (selectedMonths.contains(newIndex)) {
                                  selectedMonths.remove(newIndex);
                                } else {
                                  selectedMonths.add(newIndex);
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ),
                ],
              ),
              actions: [
                CustomButton(
                  text: "Submit",
                  mini: true,
                  onPressed: () async {
                    final formattedStartTime = DateFormat('HH:mm').format(start);
                    final formattedEndTime = DateFormat('HH:mm').format(end);
                    final formattedStartDate = DateFormat('yyyy-MM-dd').format(start);
                    final formattedEndDate = DateFormat('yyyy-MM-dd').format(end);

                    Map<String, String> body = {
                      "date1": formattedStartDate,
                      "date2": formattedEndDate,
                      "timestart": formattedStartTime,
                      "timeend": formattedEndTime,
                    };

                    if (recurrenceType == RecurrenceType.workweek) {
                      body["workweekonly"] = "true";
                    } else if (recurrenceType == RecurrenceType.weekly) {
                      List selectedWeekly = selectedWeekDays.map((index) => index + 1).toList();
                      body["repeatweekly"] = selectedWeekly.join(",");
                    } else if (recurrenceType == RecurrenceType.monthly) {
                      body["repeatmonthly"] = selectedMonths.join(",");
                    }

                    ref.read(freeTimesProvider.notifier).submitFreeTime(context, body).then((value) async {
                      if (value == 200) {
                        Navigator.pop(context);
                        CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.userProfile_times_submitted, ColorConstants.greenColor);
                      } else {
                        Navigator.pop(context);
                        CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.userProfile_failed_to_submit, ColorConstants.redColor);
                      }
                    });
                    await FreeTimeNotifier().fetchFreeTimes(context);
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: LocaleKeys.general_cancel,
                  showBorderStyle: true,
                  mini: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static logOut({required BuildContext context}) {
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
                        LocaleKeys.login_log_out,
                        style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                      ).tr(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
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
                    LocaleKeys.userProfile_log_out_title,
                    textAlign: TextAlign.center,
                    style: context.general.textTheme.bodyLarge!.copyWith(color: ColorConstants.blackColor, fontSize: 19),
                  ).tr(),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: CustomButton(
                      text: LocaleKeys.general_yes,
                      mini: true,
                      onPressed: () async {
                        await AuthServiceStorage.clearToken();
                        await AuthServiceStorage.clearStatus();
                        context.router.replaceAll([const ConnectionCheckView()]);

                        await UserUpdateNotifier().updateProfile(
                          context: context,
                          userName: "Username",
                          email: "username@gmail.com",
                        );
                        CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.userProfile_log_out_subtitle, ColorConstants.greenColor);
                      },
                      showBorderStyle: true),
                ),
                Padding(
                  padding: context.padding.normal.copyWith(top: 0),
                  child: CustomButton(text: LocaleKeys.general_no, mini: true, onPressed: () => Navigator.of(context).pop(), showBorderStyle: false),
                ),
              ],
            ),
          );
        });
  }
}
