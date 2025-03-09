import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';

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
      CustomSnackbar.showCustomSnackbar(context, 'success', "times_submitted", ColorConstants.greenColor);
      Navigator.of(context).pop();
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'error', "failed_to_submit", ColorConstants.redColor);
    }
  }
}

final freeTimesProvider = StateNotifierProvider<FreeTimeNotifier, List<FreeTimeModel>>((ref) {
  return FreeTimeNotifier();
});

class FreeTimeNotifier extends StateNotifier<List<FreeTimeModel>> {
  FreeTimeNotifier() : super([]);

  Future<List<FreeTimeModel>> fetchFreeTimes(BuildContext context) async {
    final token = await AuthServiceStorage.getToken();

    final response = await http.get(
      Uri.parse(ApiConstants.getFreeTimes),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(utf8Body) as List<dynamic>;
      List<FreeTimeModel> freeTimes = data.map((json) => FreeTimeModel.fromJson(json as Map<String, dynamic>)).toList();
      state = freeTimes;
      return freeTimes;
    } else {
      CustomSnackbar.showCustomSnackbar(context, 'error', "Failed to submit free time", ColorConstants.redColor);

      return [];

      // Handle error
    }
  }

  Future<void> deleteFreeTime(int id) async {
    final token = await AuthServiceStorage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.deleteFreeTime}/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      state = state.where((item) => item.id != id).toList();
    } else {
      // Handle error
    }
  }
}
