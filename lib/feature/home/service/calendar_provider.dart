import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarNotifier extends StateNotifier<DateTime> {
  CalendarNotifier() : super(DateTime.now());

  void updateSelectedDate(DateTime newDate) {
    state = newDate;
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, DateTime>((ref) {
  return CalendarNotifier();
});

final pageControllerProvider = Provider<PageController>((ref) {
  final selectedDate = ref.watch(calendarProvider);
  return PageController(initialPage: calculateInitialPage(selectedDate), viewportFraction: 0.3);
});

int calculateInitialPage(DateTime selectedDate) {
  var pageIndex = 0;
  for (var month = 1; month < selectedDate.month; month++) {
    pageIndex += DateTime(selectedDate.year, month + 1, 0).day;
  }
  return pageIndex + selectedDate.day - 1;
}

DateTime getDateFromIndex(int index, int year) {
  var month = 1;
  var day = index + 1;

  while (day > DateTime(year, month + 1, 0).day) {
    day -= DateTime(year, month + 1, 0).day;
    month++;
  }
  return DateTime(year, month, day);
}
