import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../config/constants.dart';
import '../../../../config/theme_manager.dart';
import '../../../../db/models/event_model.dart';
import '../../../../global_widgets/custom_app_bar.dart';
import '../../../../global_widgets/pill_button_2.dart';
import '../../../../global_widgets/primary_divider.dart';
import '../../../../global_widgets/primary_padding.dart';
import '../../../../global_widgets/snack_pill.dart';
import '../../../../providers/event_provider.dart';
import '../../../../services/services_locator.dart';
import 'event_dialog.dart';
import 'event_editing_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarView _calendarView = CalendarView.month;
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    final themeManager = getIt<ThemeManager>();
    final events = Provider.of<EventProvider>(context).events;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeManager.themeMode,
      builder: (context, theme, snapshot) {
        return Scaffold(
          backgroundColor:
              theme == ThemeMode.dark ? darkmodeLight : backgroundColorLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(
              context: context,
              isHomePage: false,
            ),
          ),
          body: Column(
            children: [
              PrimaryPadding(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Schedule',
                      style: headingStyle,
                    ),
                    PillButton2(
                      title: 'Add',
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventEditingPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Height20(),
              const PrimaryDivider(),
              const Height10(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SnackPill(
                    pillColor: _calendarView == CalendarView.month
                        ? kSSIorange
                        : Colors.transparent,
                    title: 'Month View',
                    hasBorder: true,
                    titleColor: theme == ThemeMode.dark
                        ? Colors.white
                        : _calendarView == CalendarView.month
                            ? Colors.white
                            : properBlack,
                    borderColor: theme == ThemeMode.dark
                        ? _calendarView == CalendarView.month
                            ? kSSIorange
                            : Colors.white
                        : _calendarView == CalendarView.month
                            ? kSSIorange
                            : properBlack,
                    onTap: () {
                      setState(() {
                        _calendarView = CalendarView.month;
                        _calendarController.view = _calendarView;
                      });
                    }),
                SnackPill(
                    pillColor: _calendarView == CalendarView.week
                        ? kSSIorange
                        : Colors.transparent,
                    title: 'Week View',
                    hasBorder: true,
                    titleColor: theme == ThemeMode.dark
                        ? Colors.white
                        : _calendarView == CalendarView.week
                            ? Colors.white
                            : properBlack,
                    borderColor: theme == ThemeMode.dark
                        ? _calendarView == CalendarView.week
                            ? kSSIorange
                            : Colors.white
                        : _calendarView == CalendarView.week
                            ? kSSIorange
                            : properBlack,
                    onTap: () {
                      setState(() {
                        _calendarView = CalendarView.week;
                        _calendarController.view = _calendarView;
                      });
                    }),
                SnackPill(
                    pillColor: _calendarView == CalendarView.day
                        ? kSSIorange
                        : Colors.transparent,
                    title: 'Day View',
                    titleColor: theme == ThemeMode.dark
                        ? Colors.white
                        : _calendarView == CalendarView.day
                            ? Colors.white
                            : properBlack,
                    hasBorder: true,
                    borderColor: theme == ThemeMode.dark
                        ? _calendarView == CalendarView.day
                            ? kSSIorange
                            : Colors.white
                        : _calendarView == CalendarView.day
                            ? kSSIorange
                            : properBlack,
                    onTap: () {
                      setState(() {
                        _calendarView = CalendarView.day;
                        _calendarController.view = _calendarView;
                      });
                    }),
              ]),
              const Height10(),
              const PrimaryDivider(),
              Expanded(
                  child: SfCalendar(
                view: _calendarView,
                dataSource: EventDataSource(events),
                initialSelectedDate: DateTime.now(),
                todayHighlightColor: kSSIorange,
                selectionDecoration: BoxDecoration(
                  border: Border.all(
                    color: kSSIorange,
                    width: 2,
                  ),
                ),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  // showAgenda: true,
                ),
                controller: _calendarController,
                 headerStyle: const CalendarHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: backgroundColorLight,
                          ),
                onTap: (details) {
                  if (details.appointments == null ||
                      details.appointments!.isEmpty) {
                    return;
                  }

                  final event = details.appointments!.first as Event;

                  showDialog(
                    context: context,
                    builder: (context) => EventDetailsDialog(event: event),
                  );
                },
              )),
            ],
          ),
        );
      },
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) {
    final event = getEvent(index);
    if (event.to.isBefore(DateTime.now())) {
      return Colors.grey; // Past events are grey
    } else {
      return event.backgroundColor; // Future events use their specified color
    }
  }

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}
