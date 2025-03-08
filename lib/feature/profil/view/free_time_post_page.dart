import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    return Scaffold(
      appBar: CustomAppBar(title: "Free Time Managamanet", showBackButton: true),
      body: ListView(
        padding: context.padding.normal,
        children: [
          CustomButton(
              text: dateRange == null ? "Select Date Range" : "${DateFormat('yyyy-MM-dd').format(dateRange.start)} - ${DateFormat('yyyy-MM-dd').format(dateRange.end)}",
              mini: true,
              onPressed: () {
                _selectDateRange(context, ref);
              }),
          Padding(
            padding: context.padding.verticalMedium,
            child: CustomButton(
                text: "Clear Date",
                mini: true,
                showBorderStyle: true,
                removeShadow: true,
                onPressed: () {
                  ref.read(dateRangeProvider.notifier).setDateRange(null);
                }),
          ),
          CustomButton(
              text: 'Submit ',
              mini: true,
              showBorderStyle: true,
              removeShadow: true,
              onPressed: () {
                if (dateRange != null) {
                  print(DateFormat('yyyy-MM-dd').format(dateRange.start));
                  print(DateFormat('yyyy-MM-dd').format(dateRange.end));
                  SetFreeTimeNotifier().submitFreeTime(context, DateFormat('yyyy-MM-dd').format(dateRange.start), DateFormat('yyyy-MM-dd').format(dateRange.end));
                } else {
                  CustomSnackbar.showCustomSnackbar(context, 'Error', "Please select a date range", ColorConstants.redColor);
                }
              }),
        ],
      ),
    );
  }
}
