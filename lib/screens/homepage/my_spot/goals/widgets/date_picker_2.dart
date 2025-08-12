import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youthspot/config/constants.dart';

class CustomDatePicker2 extends StatefulWidget {
  final String labelText;
  final Function(DateTime) onDateSelected;
  final bool isDoBField;
  final DateTime initialDate;
  final String? errorText;
  final bool showError;

  const CustomDatePicker2({
    super.key,
    required this.labelText,
    required this.onDateSelected,
    this.isDoBField = false,
    required this.initialDate,
    this.errorText,
    this.showError = false,
  });

  @override
  State<CustomDatePicker2> createState() => _CustomDatePicker2State();
}

class _CustomDatePicker2State extends State<CustomDatePicker2> {
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kSSIorange,// This makes the date selector circle orange
              onPrimary: Colors.white, // text color on the selected circle
              onSurface: Colors.black, // default text color
            ),
          ),
          child: child!,
        );
      },
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
    final bool showError = widget.showError && (widget.errorText != null && widget.errorText!.isNotEmpty);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: showError ? Colors.red : Colors.transparent,
                width: 1.2,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              
              children: [
                Expanded(
                  child: Text(
                    formatter.format(selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0),
              child: Text(
                widget.errorText ?? '',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}