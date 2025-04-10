import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final String text;
  final ValueChanged<TimeOfDay> onTimeSelected;

  CustomTimePicker({
    required this.initialTime,
    required this.text,
    required this.onTimeSelected,
  });

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TextEditingController _timeController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _updateTextController();
  }

  void _updateTextController() {
    final hour = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    _timeController = TextEditingController(text: '$hour:$minute $period');
  }

  DateTime roundToNearest15(DateTime dateTime) {
    int minute = dateTime.minute;
    int roundedMinute = (minute / 15).round() * 15;

    if (roundedMinute == 60) {
      return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour + 1, 0);
    }

    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, roundedMinute);
  }

  void _showCupertinoTimePicker(BuildContext context) {
    DateTime initialDateTime = roundToNearest15(
      DateTime(2000, 1, 1, _selectedTime.hour, _selectedTime.minute),
    );
    DateTime tempPicked = initialDateTime;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextButton(
                  onPressed: () {
                    final TimeOfDay pickedTime = TimeOfDay(
                      hour: tempPicked.hour,
                      minute: tempPicked.minute,
                    );
                    setState(() {
                      _selectedTime = pickedTime;
                      _updateTextController();
                      widget.onTimeSelected(_selectedTime);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  use24hFormat: false,
                  minuteInterval: 15,
                  onDateTimeChanged: (DateTime newTime) {
                    tempPicked = newTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.normal,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.text,
              style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () => _showCupertinoTimePicker(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _timeController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.userProfile_enter_time.tr(),
                    border: OutlineInputBorder(
                      borderRadius: context.border.lowBorderRadius,
                      borderSide: BorderSide(color: ColorConstants.greyColor),
                    ),
                    contentPadding: context.padding.horizontalNormal,
                  ),
                  style: context.general.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
