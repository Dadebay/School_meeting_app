import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';
import 'package:okul_com_tm/feature/profil/service/free_time_service.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

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
                _buildTimeRow(context, LocaleKeys.userProfile_free_date.tr(), freeTime.date),
                const SizedBox(height: 8),
                _buildTimeRow(context, LocaleKeys.userProfile_start_time.tr(), _formatTime(context, freeTime.timeStart)),
                const SizedBox(height: 8),
                _buildTimeRow(context, LocaleKeys.userProfile_end_time.tr(), _formatTime(context, freeTime.timeEnd)),
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

  /// Saat stringini AM/PM formatında döndürür (örnek: 2:30 PM)
  String _formatTime(BuildContext context, String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final timeOfDay = TimeOfDay(hour: hour, minute: minute);
      return timeOfDay.format(context); // AM/PM'li format
    } catch (e) {
      return time; // Hata varsa orijinal stringi döndür
    }
  }

  Widget _buildTimeRow(BuildContext context, String title, String value) {
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
          value,
          style: TextStyle(
            color: ColorConstants.primaryBlueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
