// ignore_for_file: inference_failure_on_function_invocation, inference_failure_on_function_return_type

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

enum RecurrenceType { none, workweek, weekly, monthly }

@RoutePage()
class FreeTimeManagamentView extends ConsumerWidget {
  const FreeTimeManagamentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeTimes = ref.watch(freeTimesProvider);
    print(freeTimes.length);
    print(freeTimes.length);
    print(freeTimes.length);
    print(freeTimes.length);
    print(freeTimes.length);
    print(freeTimes.length);
    print(freeTimes.length);
    return Scaffold(
      appBar: CustomAppBar(title: "time_managament", showBackButton: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: ImageSizes.small.value,
        margin: context.padding.normal,
        child: CustomButton(
          text: "set_free_time",
          mini: true,
          onPressed: () async {
            DateTime? pickedStart = await showOmniDateTimePicker(
              context: context,
              theme: ThemeData.light(useMaterial3: true),
              title: Padding(
                padding: context.padding.normal,
                child: Text("Start Time", style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              ),
              is24HourMode: true,
            );
            if (pickedStart == null) return;
            DateTime? pickedEnd = await showOmniDateTimePicker(
              context: context,
              theme: ThemeData.light(useMaterial3: true),
              title: Padding(
                padding: context.padding.normal,
                child: Text("End Time", style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: ColorConstants.primaryBlueColor)),
              ),
              is24HourMode: true,
            );

            if (pickedEnd == null || pickedEnd.isBefore(pickedStart)) {
              CustomSnackbar.showCustomSnackbar(context, "error", 'start_time_should_be_before_end_time', ColorConstants.redColor);
            } else {
              _showRecurrenceDialog(context, ref, pickedStart, pickedEnd);
            }
          },
        ),
      ),
      body: freeTimes.isEmpty
          ? CustomWidgets.emptyData(context)
          : ListView.builder(
              itemCount: freeTimes.length,
              itemBuilder: (context, index) {
                print("I am here");
                final freeTime = freeTimes[index];

                return Container(
                  padding: context.padding.normal,
                  margin: context.padding.low,
                  decoration: BoxDecoration(
                    color: ColorConstants.whiteColor,
                    border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
                    borderRadius: context.border.lowBorderRadius,
                    boxShadow: [BoxShadow(color: ColorConstants.greyColorwithOpacity, blurRadius: 5, spreadRadius: 2)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Free date: ${freeTime.date} \nFree time: ${freeTime.timeStart} to ${freeTime.timeEnd}",
                          style: context.general.textTheme.bodyLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => ref.read(freeTimesProvider.notifier).deleteFreeTime(freeTime.id, context),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

// Update the FreeTimeManagamentView's _showRecurrenceDialog method:

  void _showRecurrenceDialog(BuildContext context, WidgetRef ref, DateTime start, DateTime end) {
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
                padding: context.padding.low,
                child: ChoiceChip(
                  label: Text(
                    text,
                    style: context.general.textTheme.bodyLarge!.copyWith(
                      fontWeight: type == selectedType ? FontWeight.bold : FontWeight.w300,
                      color: type == selectedType ? ColorConstants.whiteColor : ColorConstants.blackColor,
                    ),
                  ),
                  selected: type == selectedType,
                  showCheckmark: false,
                  disabledColor: ColorConstants.greenColorwithOpacity,
                  selectedColor: ColorConstants.primaryBlueColor,
                  onSelected: (selected) => onSelected(selectedType),
                ),
              );
            }

            return AlertDialog(
              title: Center(
                child: Text(
                  "Select Recurrence",
                  style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              actionsAlignment: MainAxisAlignment.end,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Start Date : ${DateFormat('yyyy-MM-dd HH:mm').format(start)}",
                    style: context.general.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: Text(
                      "End Date :  ${DateFormat('yyyy-MM-dd HH:mm').format(end)}",
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
                        text: 'Workweek only',
                        type: recurrenceType,
                        selectedType: RecurrenceType.workweek,
                        onSelected: (type) => setState(() => recurrenceType = type),
                      ),
                      chipButton(
                        context: context,
                        text: 'Repeat Weekly',
                        type: recurrenceType,
                        selectedType: RecurrenceType.weekly,
                        onSelected: (type) => setState(() => recurrenceType = type),
                      ),
                      chipButton(
                        context: context,
                        text: 'Repeat Monthly',
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
                        children: List.generate(7, (index) {
                          return ChoiceChip(
                            label: Text(
                              ["M", "T", "W", "T", "F", "S", "S"][index],
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
                      padding: context.padding.normal,
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
                      body["repeatweekly"] = selectedWeekDays.join(",");
                    } else if (recurrenceType == RecurrenceType.monthly) {
                      body["repeatmonthly"] = selectedMonths.join(",");
                    }

                    ref
                        .read(freeTimesProvider.notifier)
                        .submitFreeTime(
                          context,
                          body,
                        )
                        .then((value) async {
                      if (value == 200) {
                        CustomSnackbar.showCustomSnackbar(context, 'success', "times_submitted", ColorConstants.greenColor);
                      } else {
                        CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit", ColorConstants.redColor);
                      }
                    });
                    await FreeTimeNotifier().fetchFreeTimes(context);

                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: "Cancel",
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
}
