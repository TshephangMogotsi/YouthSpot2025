import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../config/constants.dart';

class MoodPill extends StatelessWidget {
  const MoodPill({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: appointment.color,
        border: Border.all(
          color: appointment.color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        appointment.subject,
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: properBlack, fontSize: 18),
      ),
    );
  }
}
