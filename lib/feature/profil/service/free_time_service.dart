import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okul_com_tm/feature/profil/model/free_time_model.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';

import '../../../product/widgets/index.dart';

final freeTimesProvider = StateNotifierProvider<FreeTimeNotifier, List<FreeTimeModel>>((ref) => FreeTimeNotifier());

class FreeTimeNotifier extends StateNotifier<List<FreeTimeModel>> {
  FreeTimeNotifier() : super([]);

  Future<dynamic> submitFreeTime(BuildContext context, Map<String, String> body) async {
    final response = await _postData(ApiConstants.setFreeTime, body);
    await fetchFreeTimes(context);

    return response.statusCode;
  }

  Future<List<FreeTimeModel>> fetchFreeTimes(BuildContext context) async {
    final response = await _getData(ApiConstants.getFreeTimes);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      state = data.map((json) => FreeTimeModel.fromJson(json as Map<String, dynamic>)).toList();
      return state;
    } else {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.userProfile_failed_to_submit, ColorConstants.redColor);
      return [];
    }
  }

  Future<void> deleteFreeTime(int id, BuildContext context) async {
    final response = await _getData(ApiConstants.deleteFreeTime + id.toString());
    if (response.statusCode == 200) {
      state = state.where((item) => item.id != id).toList();
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.lessons_success, LocaleKeys.userProfile_delete_free_time, ColorConstants.greenColor);
    } else {
      CustomSnackbar.showCustomSnackbar(context, LocaleKeys.errors_title, LocaleKeys.userProfile_cannot_delete_free_time, ColorConstants.redColor);
    }
  }

  Future<dynamic> _postData(String url, Map<String, String> body) async {
    final token = await AuthServiceStorage.getToken();
    log(body.toString());
    return http.post(Uri.parse(url), headers: {'Authorization': 'Bearer $token'}, body: body);
  }

  Future<http.Response> _getData(String url) async {
    final token = await AuthServiceStorage.getToken();
    return http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  }
}
