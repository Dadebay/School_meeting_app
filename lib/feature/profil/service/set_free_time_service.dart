import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../product/widgets/index.dart';

final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, DateTimeRange?>((ref) {
  return DateRangeNotifier();
});

class DateRangeNotifier extends StateNotifier<DateTimeRange?> {
  DateRangeNotifier() : super(null);

  void setDateRange(DateTimeRange? range) {
    state = range;
  }
}

class SetFreeTimeNotifier {
  Future<void> submitFreeTime(BuildContext context, String date1, String date2) async {
    final token = await AuthServiceStorage.getToken();

    final response = await http.post(
      Uri.parse(ApiConstants.setFreeTime),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "date1": date1,
        "date2": date2,
      },
    );

    if (response.statusCode == 200) {
      CustomSnackbar.showCustomSnackbar(context, 'Success', "Free time submitted successfully", ColorConstants.greenColor);
      Navigator.of(context).pop();
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'Error', "Failed to submit free time", ColorConstants.redColor);
    }
  }
}
