// import 'dart:convert';

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';

// import '../../../product/widgets/index.dart';

// //////////////////////////////////////////////////////////////////////////////////////////////////
// class TimeOfDayRange {
//   final TimeOfDay start;
//   final TimeOfDay end;
//   TimeOfDayRange({required this.start, required this.end});
// }

// final timeRangeProvider = StateNotifierProvider<TimeRangeNotifier, TimeOfDayRange?>((ref) => TimeRangeNotifier());

// class TimeRangeNotifier extends StateNotifier<TimeOfDayRange?> {
//   TimeRangeNotifier() : super(null);
//   void setTimeRange(TimeOfDayRange? range) => state = range;
//   Future<TimeOfDay?> selectTime(BuildContext context, String helpText) async {
//     return await showTimePicker(
//       context: context,
//       helpText: helpText,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) => MediaQuery(
//         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//         child: Theme(
//           data: Theme.of(context).copyWith(
//             timePickerTheme: TimePickerThemeData(
//               helpTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     color: ColorConstants.primaryBlueColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//           ),
//           child: child!,
//         ),
//       ),
//     );
//   }

//   Future<void> selectTimeRange(BuildContext context, WidgetRef ref) async {
//     TimeOfDay? start = await selectTime(context, "select_time_range_start".tr());
//     if (start == null) return;
//     TimeOfDay? end = await selectTime(context, "select_time_range_end".tr());
//     if (end == null) return;
//     ref.read(timeRangeProvider.notifier).setTimeRange(TimeOfDayRange(start: start, end: end));
//   }
// }

// //////////////////////////////////////////////////////////////////////////////////////////////////
// final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, DateTimeRange?>((ref) => DateRangeNotifier());

// class DateRangeNotifier extends StateNotifier<DateTimeRange?> {
//   DateRangeNotifier() : super(null);

//   void setDateRange(DateTimeRange? range) => state = range;

//   Future<void> selectDateRange(BuildContext context, WidgetRef ref) async {
//     DateTime today = DateTime.now();
//     DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: today,
//       lastDate: today.add(const Duration(days: 365)),
//       helpText: "select_date_range".tr(),
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           datePickerTheme: DatePickerThemeData(
//             rangePickerHeaderHelpStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: ColorConstants.primaryBlueColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//         child: child!,
//       ),
//     );

//     if (picked != null) ref.read(dateRangeProvider.notifier).setDateRange(picked);
//   }
// }

// //////////////////////////////////////////////////////////////////////////////////////////////////
// final freeTimesProvider = StateNotifierProvider<FreeTimeNotifier, List<FreeTimeModel>>((ref) => FreeTimeNotifier());

// class FreeTimeNotifier extends StateNotifier<List<FreeTimeModel>> {
//   FreeTimeNotifier() : super([]);
//   String _formatTimeTo24Hour(String time) {
//     final dateTime = DateFormat("h:mm a").parse(time);
//     return DateFormat("HH:mm").format(dateTime);
//   }

//   Future<void> submitFreeTime(BuildContext context, String date1, String date2, String timeStart, String timeEnd) async {
//     final response = await _postData(ApiConstants.setFreeTime, {"date1": date1, "date2": date2, "timestart": _formatTimeTo24Hour(timeStart), "timeend": _formatTimeTo24Hour(timeEnd)});
//     if (response.statusCode == 200) {
//       CustomSnackbar.showCustomSnackbar(context, 'success', "times_submitted", ColorConstants.greenColor);
//       fetchFreeTimes(context);
//     } else {
//       CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit", ColorConstants.redColor);
//     }
//   }

//   Future<List<FreeTimeModel>> fetchFreeTimes(BuildContext context) async {
//     final response = await _getData(ApiConstants.getFreeTimes);
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
//       state = data.map((json) => FreeTimeModel.fromJson(json as Map<String, dynamic>)).toList();
//       return state;
//     } else {
//       CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit", ColorConstants.redColor);
//       return [];
//     }
//   }

//   Future<void> deleteFreeTime(int id, BuildContext context) async {
//     final response = await _getData(ApiConstants.deleteFreeTime + id.toString());
//     if (response.statusCode == 200) {
//       state = state.where((item) => item.id != id).toList();

//       CustomSnackbar.showCustomSnackbar(context, 'success', 'delete_free_time', ColorConstants.greenColor);
//     } else {
//       CustomSnackbar.showCustomSnackbar(context, 'error', 'cannot_delete_free_time', ColorConstants.redColor);
//     }
//   }

//   Future<http.Response> _postData(String url, Map<String, String> body) async {
//     final token = await AuthServiceStorage.getToken();
//     return http.post(Uri.parse(url), headers: {'Authorization': 'Bearer $token'}, body: body);
//   }

// ignore_for_file: strict_raw_type

//   Future<http.Response> _getData(String url) async {
//     final token = await AuthServiceStorage.getToken();
//     return http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
//   }
// }
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';

import '../../../product/widgets/index.dart';

final freeTimesProvider = StateNotifierProvider<FreeTimeNotifier, List<FreeTimeModel>>((ref) => FreeTimeNotifier());

class FreeTimeNotifier extends StateNotifier<List<FreeTimeModel>> {
  FreeTimeNotifier() : super([]);

  Future<dynamic> submitFreeTime(BuildContext context, Map<String, String> body) async {
    final response = await _postData(ApiConstants.setFreeTime, body);
    print(response.body);
    print(body);
    print("________________________________________________________________________________");
    return response.statusCode;
  }

  Future<List<FreeTimeModel>> fetchFreeTimes(BuildContext context) async {
    final response = await _getData(ApiConstants.getFreeTimes);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      state = data.map((json) => FreeTimeModel.fromJson(json as Map<String, dynamic>)).toList();
      return state;
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit", ColorConstants.redColor);
      return [];
    }
  }

  Future<void> deleteFreeTime(int id, BuildContext context) async {
    final response = await _getData(ApiConstants.deleteFreeTime + id.toString());
    if (response.statusCode == 200) {
      state = state.where((item) => item.id != id).toList();
      CustomSnackbar.showCustomSnackbar(context, 'success', 'delete_free_time', ColorConstants.greenColor);
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'error', 'cannot_delete_free_time', ColorConstants.redColor);
    }
  }

  Future _postData(String url, Map<String, String> body) async {
    final token = await AuthServiceStorage.getToken();
    log(body.toString());
    return http.post(Uri.parse(url), headers: {'Authorization': 'Bearer $token'}, body: body);
  }

  Future<http.Response> _getData(String url) async {
    final token = await AuthServiceStorage.getToken();
    return http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  }
}
