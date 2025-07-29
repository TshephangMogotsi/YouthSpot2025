import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/constants.dart';

class AddDateBar extends StatefulWidget {
  const AddDateBar({
    super.key,
    required this.displayDate,
  });

  final Function(DateTime) displayDate;

  @override
  State<AddDateBar> createState() => _AddDateBarState();
}

class _AddDateBarState extends State<AddDateBar> {
  final ValueNotifier _valueNotifier = ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Width20(),
        Expanded(
          child: DatePicker(
            DateTime.now(),
            width: 60,
            height: 100,
            initialSelectedDate: DateTime.now(),
            selectionColor: kSSIorange,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            onDateChange: (date) {
              _valueNotifier.value = date;
              setState(() {
                widget.displayDate(date);
              });
            },
          ),
        ),
      ],
    );
  }
}
