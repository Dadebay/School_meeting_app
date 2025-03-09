import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/set_free_time_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class FreeTimePage extends ConsumerWidget {
  const FreeTimePage({super.key});

  Future<void> _selectDateRange(BuildContext context, WidgetRef ref) async {
    DateTime today = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );

    if (picked != null && picked.start.isBefore(picked.end)) {
      ref.read(dateRangeProvider.notifier).setDateRange(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final freeTimes = ref.watch(freeTimesProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "time_managament", showBackButton: true),
      body: ListView.builder(
        itemCount: freeTimes.length,
        itemBuilder: (context, index) {
          final freeTime = freeTimes[index];
          return ListTile(
            title: Text("${freeTime.date} - ${freeTime.timeStart} to ${freeTime.timeEnd}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(freeTimesProvider.notifier).deleteFreeTime(freeTime.id);
              },
            ),
          );
        },
      ),
      //  ListView(
      //   padding: context.padding.normal,
      //   children: [
      //     CustomButton(
      //         text: dateRange == null ? "Select Date Range" : "${DateFormat('yyyy-MM-dd').format(dateRange.start)} - ${DateFormat('yyyy-MM-dd').format(dateRange.end)}",
      //         mini: true,
      //         onPressed: () {
      //           _selectDateRange(context, ref);
      //         }),
      //     Padding(
      //       padding: context.padding.verticalMedium,
      //       child: CustomButton(
      //           text: "Clear Date",
      //           mini: true,
      //           showBorderStyle: true,
      //           removeShadow: true,
      //           onPressed: () {
      //             ref.read(dateRangeProvider.notifier).setDateRange(null);
      //           }),
      //     ),
      //     CustomButton(
      //         text: 'Submit ',
      //         mini: true,
      //         showBorderStyle: true,
      //         removeShadow: true,
      //         onPressed: () {
      //           if (dateRange != null) {
      //             print(DateFormat('yyyy-MM-dd').format(dateRange.start));
      //             print(DateFormat('yyyy-MM-dd').format(dateRange.end));
      //             SetFreeTimeNotifier().submitFreeTime(context, DateFormat('yyyy-MM-dd').format(dateRange.start), DateFormat('yyyy-MM-dd').format(dateRange.end));
      //           } else {
      //             CustomSnackbar.showCustomSnackbar(context, 'Error', "Please select a date range", ColorConstants.redColor);
      //           }
      //         }),
      //   ],
      // ),
    );
  }
}
