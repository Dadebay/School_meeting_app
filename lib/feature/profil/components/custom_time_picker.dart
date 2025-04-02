import 'package:easy_localization/easy_localization.dart';
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
  bool isAm = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTime = widget.initialTime;
    _timeController = TextEditingController(
      text: _selectedTime.format(context), // Set initial text to selected time
    );
    isAm = _selectedTime.period == DayPeriod.am;
  }

  void _onTextChanged(String text) {
    final parts = text.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        setState(() {
          _selectedTime = TimeOfDay(hour: hour, minute: minute);
        });
        widget.onTimeSelected(_selectedTime); // Notify the parent widget
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.normal,
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(widget.text, style: context.general.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 4,
            child: Padding(
              padding: context.padding.horizontalNormal,
              child: TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: LocaleKeys.userProfile_enter_time.tr(),
                  border: OutlineInputBorder(borderRadius: context.border.lowBorderRadius, borderSide: BorderSide(color: ColorConstants.greyColor)),
                  contentPadding: context.padding.horizontalNormal,
                ),
                onChanged: _onTextChanged,
                style: context.general.textTheme.bodyLarge,
              ),
            ),
          ),
          ToggleButtons(
            isSelected: [isAm, !isAm],
            onPressed: (int index) {
              setState(() {
                isAm = index == 0;
                final newHour = isAm ? _selectedTime.hour % 12 : (_selectedTime.hour % 12) + 12;
                _selectedTime = _selectedTime.replacing(hour: newHour);
                _timeController.text = _selectedTime.format(context);
              });
              widget.onTimeSelected(_selectedTime);
            },
            borderRadius: context.border.lowBorderRadius,
            borderColor: ColorConstants.blueColorwithOpacity,
            selectedColor: ColorConstants.whiteColor,
            fillColor: ColorConstants.primaryBlueColor,
            children: [
              Padding(
                padding: context.padding.horizontalNormal,
                child: Text("AM", style: context.general.textTheme.bodyLarge),
              ),
              Padding(
                padding: context.padding.horizontalNormal,
                child: Text("PM", style: context.general.textTheme.bodyLarge),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
