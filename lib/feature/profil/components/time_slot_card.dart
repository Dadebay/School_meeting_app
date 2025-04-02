import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

import '../../../product/init/language/locale_keys.g.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({required this.freeTime, required this.ref});
  final FreeTimeModel freeTime;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.normal,
      margin: context.padding.low.copyWith(bottom: 10),
      decoration: BoxDecoration(
        color: ColorConstants.whiteColor,
        borderRadius: context.border.normalBorderRadius,
        border: Border.all(color: ColorConstants.greyColor),
        boxShadow: [BoxShadow(color: ColorConstants.greyColor, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeRow(LocaleKeys.userProfile_free_date.tr(), freeTime.date, ""),
                const SizedBox(height: 8),
                _buildTimeRow(LocaleKeys.userProfile_start_time.tr(), freeTime.timeStart.substring(0, 5), " AM"),
                const SizedBox(height: 8),
                _buildTimeRow(LocaleKeys.userProfile_end_time.tr(), freeTime.timeEnd.substring(0, 5), " PM"),
              ],
            ),
          ),
          IconButton(
            icon: Icon(IconlyLight.delete, color: ColorConstants.greyColor),
            onPressed: () => ref.read(freeTimesProvider.notifier).deleteFreeTime(int.parse(freeTime.id.toString()), context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String title, String value, String timeText) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstants.greyColor,
          ),
        ),
        Text(
          value + timeText,
          style: TextStyle(color: ColorConstants.primaryBlueColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
