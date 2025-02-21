import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rescheduleProvider = StateNotifierProvider<RescheduleNotifier, RescheduleState>(
  (ref) => RescheduleNotifier(),
);

class RescheduleState {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  RescheduleState({this.selectedDate, this.selectedTime});

  RescheduleState setDate({DateTime? selectedDate, TimeOfDay? selectedTime}) {
    print(selectedDate);
    return RescheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class RescheduleNotifier extends StateNotifier<RescheduleState> {
  RescheduleNotifier() : super(RescheduleState());

  void setDate(DateTime date) {
    state = state.setDate(selectedDate: date);
  }

  void setTime(TimeOfDay time) {
    state = state.setDate(selectedTime: time);
  }
}
