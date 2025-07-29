import 'package:youthspot/global_widgets/primary_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../config/constants.dart';
import '../../../../../config/theme_manager.dart';
import '../../../../../db/app_db.dart';
import '../../../../../db/models/mood_model.dart';
import '../../../../../services/services_locator.dart';
import '../data_source/mood_calendar_data_source.dart';
import 'mood_dialog.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  List<Mood>? moodList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMoods();
  }

  Future<void> fetchMoods() async {
    setState(() => isLoading = true);
    moodList = await SSIDatabase.instance.readAllMoods();
    setState(() => isLoading = false);
  }

  List<Appointment> _getDataSource() {
    if (moodList == null) {
      return [];
    }

    return moodList!.map((mood) {
      return Appointment(
          startTime: DateTime.parse(mood.date),
          endTime: DateTime.parse(mood.date).add(const Duration(hours: 1)),
          subject: mood.mood,
          color: getColorForMood(mood.mood),
          notes: mood.description);
    }).toList();
  }

  Color getColorForMood(String mood) {
    switch (mood) {
      case 'terrible':
        return Colors.red;
      case 'bad':
        return Colors.orange;
      case 'okay':
        return Colors.yellow;
      case 'good':
        return Colors.green;
      case 'great':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeManager.themeMode,
        builder: (context, theme, snapshot) {
          return PrimaryScaffold(
            child: Column(
              children: [
                !isLoading
                    ? Expanded(
                        child: SfCalendar(
                        
                          
                          // appointmentTextStyle: TextStyle(),
                          view: CalendarView.month,
                          todayHighlightColor: kSSIorange,
                          selectionDecoration: BoxDecoration(
                            border: Border.all(
                              color: kSSIorange,
                              width: 2,
                            ),
                          ),
                          onTap: (CalendarTapDetails details) {
                            if (details.appointments == null) {
                              return;
                            }
                            final Appointment appointment =
                                details.appointments![0];
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MoodDialog(appointment: appointment),
                            );
                          },
                          headerStyle: const CalendarHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: backgroundColorLight,
                          ),
                          monthViewSettings: const MonthViewSettings(
                           
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.appointment,
                          ),
            
                          firstDayOfWeek: 1,
                          cellBorderColor: theme == ThemeMode.dark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.black,
                          dataSource: MeetingDataSource(
                            _getDataSource(),
                          ),
                           appointmentBuilder: (context, details) {
                            final Appointment appointment = details.appointments.first;
                            return Container(
                              decoration: BoxDecoration(
                                color: appointment.color,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                appointment.subject,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
