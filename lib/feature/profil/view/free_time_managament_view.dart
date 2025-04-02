import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/components/time_slot_card.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/product/dialogs/dialogs.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class FreeTimeManagamentView extends ConsumerWidget {
  const FreeTimeManagamentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeTimes = ref.watch(freeTimesProvider);
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.userProfile_time_managament, showBackButton: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: ImageSizes.small.value,
        margin: context.padding.normal,
        child: CustomButton(
          text: LocaleKeys.userProfile_set_free_time,
          mini: true,
          onPressed: () {
            Dialogs.showDateTimePicker(context, ref);
          },
        ),
      ),
      body: freeTimes.isEmpty
          ? CustomWidgets.emptyData(context)
          : ListView.builder(
              padding: context.padding.onlyBottomHigh,
              itemCount: freeTimes.length,
              itemBuilder: (context, index) {
                final freeTime = freeTimes[index];
                return TimeSlotCard(freeTime: freeTime, ref: ref);
              },
            ),
    );
  }
}
