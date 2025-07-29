import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../config/constants.dart';
import '../../../../../config/theme_manager.dart';
import '../../../../../global_widgets/pill_button.dart';
import '../../../../../global_widgets/primary_container.dart';
import '../../../../../services/services_locator.dart';
import 'mood_pill.dart';

class MoodDialog extends StatelessWidget {
  const MoodDialog({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();

    return ValueListenableBuilder<Object>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainBorderRadius),
          ),
          backgroundColor: theme == ThemeMode.dark ? darkModeBg : backgroundColorLight,
          title: Row(
            children: [
              const Text('Mood'),
                  const Width10(),

               MoodPill(appointment: appointment),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: properBlack,
                  ),
                  const SizedBox(width: 3,),
                  //day
                  Text('${appointment.startTime.day} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                  // month
                  Text(
                      '${DateFormat('MMMM').format(appointment.startTime)} ', style: const TextStyle(fontWeight: FontWeight.w600)),
                  // year
                  Text('${appointment.startTime.year}', style: const TextStyle(fontWeight: FontWeight.w600),),
                ],
              ),
              const Height20(),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeManager.themeMode,
                builder: (context,theme, snapshot) {
                  return PrimaryContainer(
                    bgColor: theme == ThemeMode.dark ?darkmodeLight : Colors.white,
                    
                    child: Text(
                      maxLines: 4,
                      appointment.notes != null && appointment.notes!.isNotEmpty
                          ? appointment.notes!
                          : 'No notes available',
                      style: TextStyle(color: theme == ThemeMode.dark ? Colors.white : properBlack, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  );
                }
              ),
              const Height20(),
              Row(
                children: [
               
                  Expanded(
                    child: PillButton(
                      title: "Cancel",
                      backgroundColor: kSSIorange,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}