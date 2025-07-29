import 'package:flutter/material.dart';

import '../../../../../config/constants.dart';
import '../../../../../config/theme_manager.dart';
import '../../../../../services/services_locator.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    required this.title,
  });

  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? initialTime;
  final String title;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  void _showTimePicker(Color backgroundColor) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: backgroundColor,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        Color backgroundColor = theme == ThemeMode.dark ? darkmodeFore : backgroundColorLight;
        Color backgroundColor2 = theme == ThemeMode.dark ? darkmodeFore : Colors.white;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: formFieldTitle,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showTimePicker(backgroundColor),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: backgroundColor2,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 30),
                      ),
                      const Icon(Icons.access_time, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      }
    );
  }
}