import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../config/constants.dart';

class CustomDatePicker extends StatefulWidget {
  final String labelText;
  final Function(DateTime) onDateSelected;
  final bool isDoBField;
  final bool showIcon;
  final DateTime initialDate;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    required this.onDateSelected,
    this.isDoBField = false,
    this.showIcon = true,
    required this.initialDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.isDoBField ? DateTime(1900) : DateTime.now(),
      lastDate: widget.isDoBField ? DateTime.now() : DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      widget.onDateSelected(selectedDate);

      if (widget.labelText == 'Select End Date') {
        final DateTime startDate = DateTime.now();
        if (startDate.isAfter(selectedDate)) {
          widget.onDateSelected(startDate);
          setState(() {
            selectedDate = startDate;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Row(
        mainAxisAlignment:
            widget.showIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (widget.showIcon)
            const Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: kSSIorange,
                ),
                Width10()
              ],
            ),
          Text(
            formatter.format(selectedDate),
            style:
                titleStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
