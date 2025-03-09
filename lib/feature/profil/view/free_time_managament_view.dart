import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class FreeTimeManagamentView extends ConsumerWidget {
  const FreeTimeManagamentView({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeTimes = ref.watch(freeTimesProvider);
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
            await ref.read(dateRangeProvider.notifier).selectDateRange(context, ref);
            await ref.read(timeRangeProvider.notifier).selectTimeRange(context, ref);
            final updatedDateRange = ref.read(dateRangeProvider);
            final updatedTimeRange = ref.read(timeRangeProvider);
            if (updatedDateRange != null && updatedTimeRange != null) {
              ref.read(freeTimesProvider.notifier).submitFreeTime(
                    context,
                    DateFormat('yyyy-MM-dd').format(updatedDateRange.start),
                    DateFormat('yyyy-MM-dd').format(updatedDateRange.end),
                    updatedTimeRange.start.format(context),
                    updatedTimeRange.end.format(context),
                  );
            } else {
              CustomSnackbar.showCustomSnackbar(context, "error", "error_date_range", Colors.red);
            }
          },
        ),
      ),
      body: ListView.builder(
        itemCount: freeTimes.length,
        itemBuilder: (context, index) {
          final freeTime = freeTimes[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: context.padding.low,
            decoration: BoxDecoration(
              color: ColorConstants.whiteColor,
              border: Border.all(color: ColorConstants.blackColor.withOpacity(.2)),
              borderRadius: context.border.lowBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.greyColorwithOpacity,
                  blurRadius: 5,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Free date : ${freeTime.date} \nFree time : ${freeTime.timeStart}   to   ${freeTime.timeEnd}",
                    style: context.general.textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(IconlyLight.delete),
                  onPressed: () {
                    ref.read(freeTimesProvider.notifier).deleteFreeTime(freeTime.id, context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
